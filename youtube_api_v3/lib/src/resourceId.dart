class ResourceId{
  final String kind;
  final String videoId;
  ResourceId(this.kind,this.videoId);
  factory ResourceId.fromJson(Map<String,dynamic> json){
    return ResourceId(
      json['kind'],
      json['videoId']
    );
  }
}