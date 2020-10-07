class Setting {
  double precipitationAmount;
  double precipitationDuration;
  int precipitationAmountChance;
  int groundWaterLevel;
  int basementDepth;
  bool showPrecipitationAmountAndDuration = false;
  bool showPrecipitationChance = false;
  bool showGroundWaterLevel = false;

  Setting(
      {this.precipitationAmount,
      this.precipitationDuration,
      this.precipitationAmountChance,
      this.groundWaterLevel,
      this.basementDepth,
      this.showPrecipitationAmountAndDuration,
      this.showPrecipitationChance,
      this.showGroundWaterLevel});

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
        precipitationAmount: double.tryParse(json["precipitationAmount"].toString()),
        precipitationDuration: double.tryParse(json["precipitationDuration"].toString()),
        precipitationAmountChance: int.tryParse(json["precipitationAmountChance"].toString()),
        groundWaterLevel: int.tryParse(json["groundWaterLevel"].toString()),
        basementDepth: int.tryParse(json["basementDepth"].toString()),
        showPrecipitationAmountAndDuration: json["showPrecipitationAmountAndDuration"] as bool,
        showPrecipitationChance: json["showPrecipitationChance"] as bool,
        showGroundWaterLevel: json["showGroundWaterLevel"] as bool);
  }

  Map<String, dynamic> toJson() => {
        "precipitationAmount": precipitationAmount,
        "precipitationDuration": precipitationDuration,
        "precipitationAmountChance": precipitationAmountChance,
        "groundWaterLevel": groundWaterLevel,
        "basementDepth": basementDepth,
        "showPrecipitationAmountAndDuration": showPrecipitationAmountAndDuration,
        "showPrecipitationChance": showPrecipitationChance,
        "showGroundWaterLevel": showGroundWaterLevel
      };

  @override
  String toString() {
    return "Config{precipitationAmount: $precipitationAmount, precipitationDuration: $precipitationDuration, precipitationAmountChance: $precipitationAmountChance, groundWaterLevel: $groundWaterLevel, basementDepth: $basementDepth, showPrecipitationAmountAndDuration: $showPrecipitationAmountAndDuration, showPrecipitationChance: $showPrecipitationChance, showGroundWaterLevel: $showGroundWaterLevel}";
  }
}
