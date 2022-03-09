class LiveApi {
  String directUrl;

  String date;
  String error;
  LiveApi({this.directUrl,this.date,this.error});
  LiveApi.withError(String errorMessage){
    error = errorMessage;
  }

  LiveApi.fromJson(Map<String, dynamic> json) {
    directUrl = json['direct_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['direct_url'] = this.directUrl;
    return data;
  }
}
