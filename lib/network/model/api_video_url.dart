class VideoUrl {
  String videoUrl;

  VideoUrl({this.videoUrl,this.error,this.date});
  String date;
  String error;
  VideoUrl.withError(String errorMessage){
    error = errorMessage;
  }

  VideoUrl.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_url'] = this.videoUrl;
    return data;
  }
}
