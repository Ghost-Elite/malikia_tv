class ContentDetails{
  final String videoId;
  final String videoPublishedAt;

  ContentDetails(this.videoId,this.videoPublishedAt);

  factory ContentDetails.fromJson(Map<String,dynamic> json){
    return ContentDetails(
      json['videoId'],
      json['videoPublishedAt']
    );
  }
}