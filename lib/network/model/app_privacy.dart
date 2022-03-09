class Appprivacy {
  String appPrivacy;

  Appprivacy({this.appPrivacy,this.error,this.date});
  String date;
  String error;
  Appprivacy.withError(String errorMessage){
    error = errorMessage;
  }

  Appprivacy.fromJson(Map<String, dynamic> json) {
    appPrivacy = json['app_privacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_privacy'] = this.appPrivacy;
    return data;
  }
}
