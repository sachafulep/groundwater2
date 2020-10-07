import "package:flutter/material.dart";
import "package:groundwater/model/data/lectoraat/monitoring_well_measurement.dart";
import "package:groundwater/model/data/note/note.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";
import "package:intl/intl.dart";

class Notes extends StatelessWidget {
  Notes({
    this.selectedMeasurement,
    this.notes,
    this.editNoteDialog,
    this.createNoteDialog,
  });

  final MonitoringWellMeasurement selectedMeasurement;
  final List<Note> notes;
  final Function(Note note) editNoteDialog;
  final Function() createNoteDialog;

  @override
  Widget build(BuildContext context) {
    DateTime time = selectedMeasurement.sensorTimestamp;
    String dateString = DateFormat("HH:mm - d MMMM y", "nl_NL").format(time);

    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dateString,
              style: TextStyle(color: GroundColor.subText, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          for (Note note in notes.where((note) => note.dataPointId == selectedMeasurement.id).toList())
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                color: GroundColor.primaryDark,
              ),
              child: InkWell(
                onTap: () => editNoteDialog(note),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        note.user.name,
                        style: TextStyle(color: GroundColor.accent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                      child: Text(
                        note.description,
                        style: TextStyle(color: GroundColor.subText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 48,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(Strings.detailsAddNoteTitle),
              color: Theme.of(context).buttonColor,
              onPressed: () => createNoteDialog(),
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
