class Appdescription {
  String appDescription;

  Appdescription({this.appDescription,this.date,this.error});
  String date;
  String error;
  Appdescription.withError(String errorMessage){
    error = errorMessage;
  }

  Appdescription.fromJson(Map<String, dynamic> json) {
    appDescription = json['app_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_description'] = this.appDescription;
    return data;
  }
}
