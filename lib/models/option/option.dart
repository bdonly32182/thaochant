class OptionModel {
  String businessId;
  String optionName;
  String conditionName;
  List<Map<String,dynamic>> option;
  int min;
  int max;
  

  OptionModel(
    this.businessId,
    this.conditionName,
    this.optionName,
    this.option,
    this.max,
    this.min,
  );
}
