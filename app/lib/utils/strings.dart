import "package:groundwater/model/data/setting/precipitation_amount_options.dart";
import "package:groundwater/model/data/setting/precipitation_duration_options.dart";

/// Class where all the strings for the app are stored.
class Strings {
  /// Common
  static final ok = "Oké";
  static final cancel = "Annuleren";
  static final delete = "Verwijderen";
  static final save = "Opslaan";
  static final notificationChannelGeneralTitle = "Algemeen";
  static final notificationChannelGeneralDescription = "Algemene informatie";
  static final saveFailed = "Opslaan mislukt";

  /// Dashboard
  static final dashboardAppBarTitle = "Dashboard";
  static final dashboardNavigateToDetails = "Geavanceerde inzichten";
  static final maximumExpectedNextDay = "* Maximaal verwachte hoogte de komende 24 uur";
  static final currentWaterLevel = "Huidig grondwaterniveau";
  static final estimatedWaterLevel = "Verwacht grondwaterniveau*";
  static final setCellarLevel = "Klik om een kelder\ndiepte in te stellen.";
  static String amountOfCm(int x) => "$x cm";
  static String lastUpdated(String x) => "Laatste update:\n$x";

  /// Decision Tree
  static final decisionTreeAppBarTitle = "Beslisboom";
  static final decisionTreeExplanationTitle = "Wat kunt u met de beslisboom";
  static final decisionTreeExplanationBody = "Om te bepalen wat de best mogelijke oplossing is voor uw huis kunnen we op basis van een paar vragen meer inzicht krijgen in uw situatie en er mogelijk een passende oplossing of verbetering voor vinden. U krijgt een aantal multiplechoice vragen die u naar echtheid dient in te vullen.";
  static final decisionTreeStart = "Beginnen";
  static final decisionTreePrevious = "Vorige";
  static final decisionTreeNext = "Volgende";
  static final decisionTreeFinish = "Finish";
  static final decisionTreeMapTitle = "Kies in de afbeelding uw omgeving, of doe dit door middel van uw GPS locatie.";
  static final west = "West";
  static final middle = "Midden";
  static final east = "Oost";
  static const locationWest = "Enschede West & Glanerbrug";
  static const locationMiddle = "Enschede Midden";
  static const locationEast = "Enschede Oost";
  static final noLocationSelected = "Geen locatie geselecteerd";
  static final locationGPS = "Locatie via GPS";
  static final location = "Locatie";
  static final callToAction = "Druk op de kopjes voor meer informatie.";

  /// Details
  static final detailsAppBarTitle = "Geavanceerde inzichten";
  static final detailsChooseDateRange = "Kies datum bereik";
  static final detailsAddNoteTitle = "Voeg notitie toe";
  static final detailsEditNoteTitle = "Bewerk notitie";
  static final detailsNoteHint = "Notitie";
  static final detailsChooseSensorAction = "Kies een sensor";
  static final detailsChooseSensorDialogTitle = "Kies sensoren";
  static final detailsChooseSensorDialogBody = "Kies welke sensoren moeten worden weergegeven in de grafiek.";
  static final legendSensors = "Sensors";
  static final legendPrecipitation = "Neerslag";
  static final togglePrecipitation = "Toon neerslag data";
  static final chartTitleRight = "Neerslag (in mm per uur)";
  static final chartTitleLeft = "Grondwater niveau (in cm)";

  /// Intro
  static final introFirstTitle = "Welkom";
  static final introFirstBody = "Met deze app geven we u inzicht in wat u kunt veranderen aan uw omgeving om de problemen als gevolg van het grondwater verminderen.";
  static final introSecondTitle = "Sensor";
  static final introSecondBody = "Om u van zo accuraat mogelijke data te voorzien wordt er zodadelijk gevraagd om informatie over uw sensor. Alleerst moeten wij weten of u al een sensor heeft geregistreerd, of dat u een sensor voor het eerst wil registeren.";
  static final introSecondAlreadyRegisteredAction = "Sensor is al geregistreerd";
  static final introSecondRegisterNewAction = "Nieuwe sensor registreren";
  static final introPrevious = "Vorige";
  static final introNext = "Volgende";

  /// Login
  static final loginAppBarTitle = "Login";
  static final loginTitle = "Log in";
  static final loginSensorBody = "Voordat u kan inloggen hebben we eerst uw unieke sensor nummer nodig, zodat we kunnen verifïeren dat u eigenaar bent van een sensor.";
  static final loginSensorFieldTitle = "Uniek sensor nummer";
  static final loginSensorInvalidUuid = "Ongeldig sensor nummer";
  static final loginSensorActionContinue = "Doorgaan";
  static final loginSensorHintText = "Heeft u al een account? ";
  static final loginSensorHintTextAction = "Inloggen";
  static final loginAuthenticateHintText = "* Hierdoor ontvangen wij uw naam en email adres, die uitsluitend worden gebruikt voor het personaliseren van de app.";
  static final loginAuthenticateBody = "U kunt inloggen of een account aanmaken door middel van uw Google of Facebook account*";
  static final loginAuthenticateActionGoogle = "Doorgaan met Google";
  static final loginAuthenticateActionFacebook = "Doorgaan met Facebook";
  static final loginAuthenticateFailedToLogin = "Inloggen mislukt, probeer het opnieuw";

  /// Settings
  static final settingsAppBarTitle = "Instellingen";
  static final settingsHeaderGeneral = "Algemeen";
  static final settingsGoToNotificationsTitle = "Meldingen";
  static final settingsGoToNotificationsDescription = "Stel uw melding voorkeuren in";
  static final settingsGoToSensorsTitle = "Hoofdsensor";
  static final settingsGoToSensorsDescription = "Geen sensor gevonden";
  static final settingsHeaderProfile = "Mijn profiel";
  static final settingsProfileName = "Naam";
  static final settingsProfileEmail = "Email";
  static final settingsProfileSaveChanges = "Update profiel";
  static final settingsProfileSaveSuccess = "Profiel aangepast";
  static final settingsProfileSaveFailed = "Updaten mislukt";

  static final settingsSensorsAppBarTitle = "Selecteer sensor";
  static final settingsSensorsSubtext = "Kies een sensor die u als hoofdsensor wilt gebruiken of registreer een nieuwe sensor";
  static final settingsSensorsAddSensor = "Nieuwe sensor registreren";
  static final settingsSensorsEditSensor = "Huidige sensor bewerken";
  static final settingsNotificationsAppBarTitle = "Meldingen";
  static final settingsNotificationsSubtext = "Schakel specifieke meldingen in of uit";

  static final settingsNotificationsNotificationsTitle = "Meldingen configureren";
  static final settingsNotificationsNotificationsDescription = "Kies welke meldingen u wel en niet wilt ontvangen";
  static final settingsNotificationsNotificationsDialogTitle = "Meldingen configureren";
  static final settingsNotificationsNotificationsDialogDescription = "Kies welke meldingen u wel en niet wilt ontvangen";

  static final settingsNotificationsNotificationsDialogPrecipitationTitle = "Neerslag" ;
  static final settingsNotificationsNotificationsDialogPrecipitationDescription = "Ontvang meldingen wanneer er neerslag wordt verwacht" ;
  static final settingsNotificationsNotificationsDialogPrecipitationChanceTitle = "Neerslag kans" ;
  static final settingsNotificationsNotificationsDialogPrecipitationChanceDescription = "Ontvang meldingen wanneer de kans meer dan het ingestelde percentage is" ;
  static final settingsNotificationsNotificationsDialogGroundWaterLevelTitle = "Grondwater niveau" ;
  static final settingsNotificationsNotificationsDialogGroundWaterLevelDescription = "Ontvang meldingen wanneer het grondwater niveau boven de ingestelde waarde komt" ;

  static final settingsNotificationsPrecipitationTitle = "Neerslag";
  static final settingsNotificationsPrecipitationDescription = "Verander de melding wanneer er neerslag wordt verwacht";
  static final settingsNotificationsPrecipitationDialogTitle = "Stel een schema op";

  static String settingsNotificationsPrecipitationDialogDescription(PrecipitationAmountOptions amountOption,
    PrecipitationDurationOptions durationOption) {
    String amount;
    String duration;

    if (amountOption == PrecipitationAmountOptions.half) {
      amount = settingsNotificationsPrecipitationDialogAmountOptionOne;
    } else if (amountOption == PrecipitationAmountOptions.twoAndAHalf) {
      amount = settingsNotificationsPrecipitationDialogAmountOptionTwo;
    } else if (amountOption == PrecipitationAmountOptions.five) {
      amount = settingsNotificationsPrecipitationDialogAmountOptionThree;
    } else if (amountOption == PrecipitationAmountOptions.ten) {
      amount = settingsNotificationsPrecipitationDialogAmountOptionFour;
    } else if (amountOption == PrecipitationAmountOptions.twenty) {
      amount = settingsNotificationsPrecipitationDialogAmountOptionFive;
    }

    if (durationOption == PrecipitationDurationOptions.none) {
      durationOption = null;
    } else if (durationOption == PrecipitationDurationOptions.halfHour) {
      duration = settingsNotificationsPrecipitationDialogDurationOptionTwo(showMoreThanSymbol: false);
    } else if (durationOption == PrecipitationDurationOptions.oneHour) {
      duration = settingsNotificationsPrecipitationDialogDurationOptionThree(showMoreThanSymbol: false);
    } else if (durationOption == PrecipitationDurationOptions.twoHours) {
      duration = settingsNotificationsPrecipitationDialogDurationOptionFour(showMoreThanSymbol: false);
    } else if (durationOption == PrecipitationDurationOptions.fourHours) {
      duration = settingsNotificationsPrecipitationDialogDurationOptionFive(showMoreThanSymbol: false);
    }

    if (amount == null && duration == null) {
      return "U heeft momenteel niks ingesteld";
    } else if (amount == null) {
      return "Ontvang een melding als de regen meer dan $duration aan houdt";
    } else if (duration == null) {
      return "Ontvang een melding als er meer dan $amount regen valt";
    } else {
      return "Bij $amount regen krijgt u een melding als de regen meer dan $duration aan houdt.";
    }
  }

  static final settingsNotificationsPrecipitationDialogAmountOptionOne = "0.5 mm";
  static final settingsNotificationsPrecipitationDialogAmountOptionTwo = "2.5 mm";
  static final settingsNotificationsPrecipitationDialogAmountOptionThree = "5 mm";
  static final settingsNotificationsPrecipitationDialogAmountOptionFour = "10 mm";
  static final settingsNotificationsPrecipitationDialogAmountOptionFive = "20 mm";
  static final settingsNotificationsPrecipitationDialogDurationOptionOne = "Niet";
  static String settingsNotificationsPrecipitationDialogDurationOptionTwo({bool showMoreThanSymbol = true}) => "${showMoreThanSymbol? "> ": ""}0.5 uur";
  static String settingsNotificationsPrecipitationDialogDurationOptionThree({bool showMoreThanSymbol = true})=> "${showMoreThanSymbol? "> ": ""}1 uur";
  static String settingsNotificationsPrecipitationDialogDurationOptionFour({bool showMoreThanSymbol = true}) => "${showMoreThanSymbol? "> ": ""}2 uur";
  static String settingsNotificationsPrecipitationDialogDurationOptionFive({bool showMoreThanSymbol = true}) => "${showMoreThanSymbol? "> ": ""}4 uur";

  static final settingsNotificationsGroundWaterLevelTitle = "Grondwater niveau";
  static final settingsNotificationsGroundWaterLevelDescription = "Hoe diep moet het grondwaterniveau zijn om een melding te ontvangen";
  static final settingsNotificationsGroundWaterLevelDialogTitle = "Voer diepte in (cm)";
  static final settingsNotificationsGroundWaterLevelDialogDescription = "Hoe diep moet het grondwaterniveau zijn om een melding te ontvangen";
  static final settingsNotificationsGroundWaterLevelDialogInput = "Diepte grondwaterniveau";
  static final settingsNotificationsGroundWaterLevelDialogError = "Vul aub een grondwater niveau in";

  static final settingsNotificationsPrecipitationChanceTitle = "Neerslag kans";
  static final settingsNotificationsPrecipitationChanceDescription = "Hoe groot moet de kans op neerslag zijn om een melding te ontvangen";
  static final settingsNotificationsPrecipitationChanceDialogTitle = "Voer kans in (%)";
  static final settingsNotificationsPrecipitationChanceDialogDescription = "Hoe groot moet de kans op neerslag zijn om een melding te ontvangen";
  static final settingsNotificationsPrecipitationChanceDialogInput = "Kans op neerslag (%)";
  static final settingsNotificationsPrecipitationChanceDialogError = "Vul aub een neerslag kans percentage in";
  static final settingsNotificationsPrecipitationChanceDialogErrorRange = "Vul aub een neerslag kans percentage tussen 0% en 100% in";

  /// Edit sensor
  static final editSensorTitle = "Bewerk sensor";
  static final editSensorAddress = "Adres";
  static final editSensorAddressHint = "Adres";
  static final editSensorCellarHeight = "Kelder diepte onder de grond (cm)";
  static final editSensorCellarHeightHint = "Diepte";
  static final editSensorUpdateSensor = "Sensor Opslaan";
  static final editSensorUpdateSensorFailed = "Er is iets fout gegaan bij het opslaan";
}
