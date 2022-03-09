class Thumbnail{
  final String url;
  final int width;
  final int height;

  Thumbnail(this.url,this.width,this.height);

  factory Thumbnail.fromJson(Map<String,dynamic> json){
    return Thumbnail(
      json['url'],
      json['width'],
      json['height']
    );
  }
}