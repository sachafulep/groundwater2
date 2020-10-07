import "dart:collection";

import "package:charts_flutter/flutter.dart";
import "package:charts_flutter/flutter.dart" as charts;
import "package:date_range_picker/date_range_picker.dart" as picker;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:groundwater/model/data/lectoraat/monitoring_well_measurement.dart";
import "package:groundwater/model/data/weather/weather_measurement.dart";
import "package:groundwater/model/data/note/note.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/network/lectoraat_api.dart";
import "package:groundwater/network/weather_api.dart";
import "package:groundwater/ui/details/buttons.dart";
import "package:groundwater/ui/details/graph.dart";
import "package:groundwater/ui/details/notes.dart";
import "package:groundwater/ui/details/pick_sensor_dialog.dart";
import "package:groundwater/utils/strings.dart";

import "add_note_dialog.dart";

class Details extends StatefulWidget {
  static const routeName = "/details";

  Details({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  static const secondaryMeasureAxisId = "secondaryMeasureAxisId";
  MonitoringWellMeasurement selectedMeasurement;
  LectoraatApi lectoraatApi = LectoraatApi();
  WeatherApi weatherApi = WeatherApi();
  DateTime _startDateTime = DateTime.now().subtract(Duration(days: 3));
  DateTime _endDateTime = DateTime.now().add(Duration(days: 3));
  PickedSensorCallback pickedSensorCallback;
  HashMap<Sensor, List<MonitoringWellMeasurement>> monitoringWellMeasurements = HashMap();
  HashMap<Sensor, Color> sensorColorPairings = HashMap();
  String _dateRange = Strings.detailsChooseDateRange;
  String graphState = "true";
  int _daysInRange = 0;
  bool _initialLoad = true;
  bool precipitationEnabled = true;
  bool reset = false;
  List<Sensor> pickedSensors = [];
  List<Note> notes = [];
  List<WeatherMeasurement> weatherMeasurements = [];
  List<Color> colors = [
    charts.MaterialPalette.blue.shadeDefault,
    charts.MaterialPalette.cyan.shadeDefault,
    charts.MaterialPalette.deepOrange.shadeDefault,
    charts.MaterialPalette.gray.shadeDefault,
    charts.MaterialPalette.green.shadeDefault,
    charts.MaterialPalette.indigo.shadeDefault,
    charts.MaterialPalette.lime.shadeDefault,
    charts.MaterialPalette.pink.shadeDefault,
    charts.MaterialPalette.purple.shadeDefault,
    charts.MaterialPalette.red.shadeDefault,
    charts.MaterialPalette.teal.shadeDefault,
    charts.MaterialPalette.yellow.shadeDefault,
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _formatDate();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (_initialLoad) {
      _initialLoad = false;
      _getDefaultMeasurements();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.detailsAppBarTitle),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _legend(),
              Container(
                height: 200,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Graph(
                  graphReset: () => _graphReset(),
                  graphState: graphState,
                  monitoringWellMeasurements: monitoringWellMeasurements,
                  onSelectionChanged: (charts.SelectionModel model) => _onSelectionChanged(model),
                  precipitationEnabled: precipitationEnabled,
                  selectedMeasurement: selectedMeasurement,
                  sensorColorPairings: sensorColorPairings,
                  weatherMeasurements: weatherMeasurements,
                ),
              ),
              Buttons(
                dateRange: _dateRange,
                graphReset: () => _graphReset(),
                toggleGraphState: () => toggleGraphState(),
                pickDate: () => _pickDate(),
                pickedSensors: pickedSensors,
                precipitationEnabled: precipitationEnabled,
                showSensorDialog: () => showSensorDialog(),
              ),
              if (selectedMeasurement != null)
                Notes(
                  createNoteDialog: () => createNoteDialog(),
                  editNoteDialog: (note) => editNoteDialog(note),
                  notes: notes,
                  selectedMeasurement: selectedMeasurement,
                )
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final List<DateTime> picked = await picker.showDatePicker(
      context: context,
      initialFirstDate: _startDateTime,
      initialLastDate: _endDateTime,
      firstDate: DateTime(2019),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );

    if (picked != null) {
      setState(() {
        _startDateTime = picked.first;
        _endDateTime = picked.last;

        _formatDate();
      });

      _getMeasurements();
    }
  }

  void _formatDate() {
    _daysInRange = _endDateTime.difference(_startDateTime).inDays + 1;

    String formattedStartDate = "${_startDateTime.day}-${_startDateTime.month}-${_startDateTime.year}";

    String formattedEndDate = "${_endDateTime.day}-${_endDateTime.month}-${_endDateTime.year}";

    if (_daysInRange > 1) {
      _dateRange = "$formattedStartDate / $formattedEndDate";
    } else {
      _dateRange = "$formattedStartDate";
    }
  }

  void _getDefaultMeasurements() async {
    Sensor mainSensor = await Model().getMainSensor();
    int wellId = mainSensor.externalMonitoringWellId;

    List<MonitoringWellMeasurement> temp = await lectoraatApi.requestMonitoringWellMeasurements(_startDateTime, _endDateTime, wellId);

    pickedSensors.add(mainSensor);
    sensorColorPairings[mainSensor] = colors[0];

    // TODO - remove hardcoded coordinates
    List<WeatherMeasurement> _forecast = await WeatherApi().requestForecast(_startDateTime, _endDateTime, 52.22, 6.9);

    setState(() {
      monitoringWellMeasurements[mainSensor] = temp;
      weatherMeasurements = _forecast;
    });
  }

  void _savePickedSensors(List<Sensor> sensors) {
    int index = 0;
    sensorColorPairings.clear();

    sensors.forEach((sensor) => {
          sensorColorPairings[sensor] = colors[index],
          index++,
          if (index == colors.length) index = 0,
        });

    setState(() {
      pickedSensors = sensors;
    });

    _getNotes();
    _getMeasurements();
  }

  void _saveNote({String newNote, Note existingNote}) async {
    if (selectedMeasurement == null) return;

    // Create a new note
    if (newNote != null) {
      int dataPointId = selectedMeasurement.id;
      int monitoringWellId = selectedMeasurement.monitoringWell;

      Note createdNote = await Model().api.createNote(dataPointId, monitoringWellId, newNote);
      if (createdNote == null) {
        // Todo error message
        return;
      }
      setState(() {
        notes.add(createdNote);
      });
      return;
    }

    // Update an existing note
    if (existingNote != null) {
      Note updatedNote = await Model().api.updateNote(existingNote.id, existingNote.description);
      if (updatedNote == null) {
        // Todo error message
        return;
      }
      setState(() {
        notes.remove(existingNote);
        notes.add(updatedNote);
      });
      return;
    }
  }

  void _deleteNote(Note note) async {
    if (await Model().api.deleteNote(note.id) == true) {
      setState(() {
        notes.remove(note);
      });
    } else {
      // Todo error message
    }
  }

  void _getMeasurements() async {
    if (pickedSensors.isEmpty || _dateRange == Strings.detailsChooseDateRange) return;

    var temp1 = await _getMonitoringWellMeasurements();
    var temp2 = await _getWeatherMeasurements();

    setState(() {
      monitoringWellMeasurements = temp1;
      weatherMeasurements = temp2;
    });
  }

  Future<HashMap<Sensor, List<MonitoringWellMeasurement>>> _getMonitoringWellMeasurements() async {
    // If there is no sensor selected or no date range selected don't get the measurements
    HashMap<Sensor, List<MonitoringWellMeasurement>> tempMeasurements = HashMap();

    for (Sensor sensor in pickedSensors) {
      int wellId = sensor.externalMonitoringWellId;

      List<MonitoringWellMeasurement> temp = [];

      if (_daysInRange > 31) {
        temp = await lectoraatApi.requestCombinedMonitoringWellMeasurements(_startDateTime, _endDateTime, wellId);
      } else {
        temp = await lectoraatApi.requestMonitoringWellMeasurements(_startDateTime, _endDateTime, wellId);
      }

      tempMeasurements[sensor] = temp;
    }

    return tempMeasurements;
  }

  Future<List<WeatherMeasurement>> _getWeatherMeasurements() async {
    return await weatherApi.requestForecast(_startDateTime, _endDateTime, 52.22, 6.9);
  }

  void _getNotes() async {
    List<int> monitoringWellIds = pickedSensors.map((sensor) => sensor.externalMonitoringWellId).toList();

    List<Note> notes = await Model().api.getNotesByMonitoringWellIds(monitoringWellIds);
    setState(() {
      this.notes = notes ?? [];
    });
  }

  void toggleGraphState() {
    setState(() {
      precipitationEnabled = !precipitationEnabled;
    });
  }

  void showSensorDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return PickSensorDialog(
          pickedSensorCallback: _savePickedSensors,
          previousPickedSensorIds: pickedSensors.map((sensor) => sensor.internalId).toList(),
        );
      },
    );
  }

  void editNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (_) {
        return AddNoteDialog(
          saveNoteCallback: _saveNote,
          note: note,
          deleteNoteCallback: _deleteNote,
        );
      },
    );
  }

  void createNoteDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AddNoteDialog(
          saveNoteCallback: _saveNote,
          note: null,
        );
      },
    );
  }

  dynamic _onSelectionChanged(charts.SelectionModel model) {
    bool once = true;

    if (model.selectedDatum.isNotEmpty) {
      model.selectedDatum.forEach((charts.SeriesDatum datumPair) {
        if (once) {
          setState(() {
            selectedMeasurement = datumPair.datum as MonitoringWellMeasurement;
          });
          once = false;
        }
      });
    }
  }

  Widget _legend() {
    double screenWidth = MediaQuery.of(context).size.width;
    int amountOfRows = (sensorColorPairings.length / (screenWidth / 60) + 0.49).round();
    double height = amountOfRows * 20.0;

    return Container(
        width: screenWidth,
        height: height,
        child: CustomPaint(
            foregroundPainter: LegendIconPainter(
          precipitationEnabled: precipitationEnabled,
          sensorColorPairings: sensorColorPairings,
          screenWidth: screenWidth,
        )));
  }

  void _graphReset() {
    setState(() {
      graphState = "false";
    });
  }
}
