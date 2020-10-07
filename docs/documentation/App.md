# App (Flutter + Dart)
## Intro
In the intro we tell the user a bit about the app, what they can do with it and some more info regarding their sensor. They will be asked if they already have a sensor, or if they would like to register a new sensor. When the user selects the "already have a sensor", they will be redirected to the authentication page. If they select "register new sensor", they will go to the sensor registration page where they can register a sensor via Bluetooth pairing.

## Authentication
The user first has to enter it's sensor UUID. This is used to verify that the user is a genuine sensor owner and has registered the sensor. If the user indeed has a valid sensor, he / she can log in via OAuth. We currently only use Google, but plan to support Facebook in the future too. We use OAuth to make it less of a hassle for people to use the app.

## Dashboard
The visualisation displays the current state of the user's sensor readings. The grey area is a basement, the dark blue color is the current ground water level and the translucent blue color is used to show the estimated ground water level. This is dynamically updated based on readings from the sensors and the weather.

The total height of the ground is calculated by using the MonitoringWell data that belongs to the sensor:
	totalLength (totale_lengte) + (groundLevel (maaiveld) - topMonitoringWell (bovenkant_peilbuis))
The height in meters that the MonitoringWell is under the ground equals groundlevel - topMonitoringWell which are both ASL values.

The data shown in the visualization is the last received measurement of the main sensor from the user. Thus if for example the battery of a sensor is empty, the data maybe old. Because of this a last retrieved text is shown at the bottom of the visualization.

The current water level in the visualization equals the levelFromGround value of a SensorMeasurement

## Details
### Date range selection
Clicking the date range button opens a date picker dialog which allows picking either a single date, or a date range. After making a selection and pressing "ok" a request function is called in LectoraatAPI.dart which makes a request to the Directus API for "pijlbuismetingen". 

A list of these measurements is created from the response body which get passed back to the DetailsState.
### Graph
By default the graph will show an overview of measurements for the last seven days. On user selection of a date range the graph will show the measurements for the user's selected range instead.

The nodes on the lines in the graph have an on click feature which allows users to select a specific point. One a point is selected it will display a tag with the value of that point.

### Sensor selection
An dialog will be shown with all sensors that are retrieved from the backend. The user can select as many sensors as it wants, and after it has saved the selection, the graph should load in the data from the sensors. The user can, at any time, change it's selection of sensors. 

### Precipitation toggle
By default precipitation data is shown in the graph. This line in the graph is differentiated by it's dot pattern instead of an uninterupted line. The graph shows an extra graph title and graph markings along with an entry in the legend for the precipitation data. (These appear or dissapear when visibility is toggled.)

## Settings

## Sensors

# Class Diagram
<img alt="Class Diagram" src="../images/App%20Class%20Diagram.svg">