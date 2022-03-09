
import '../youtube_api_v3.dart';

class Thumbnails{
  final Thumbnail defaulT;
  final Thumbnail medium;
  final Thumbnail high;
  final Thumbnail standard;
  final Thumbnail maxres;

  Thumbnails(this.defaulT,this.medium,this.high,this.standard,this.maxres);
  factory Thumbnails.fromJson(Map<String,dynamic> json){
    return Thumbnails(
      Thumbnail.fromJson(json['default']),
      Thumbnail.fromJson(json['medium']),
      Thumbnail.fromJson(json['high']),
      Thumbnail.fromJson(json['standard']),
      Thumbnail.fromJson(json['maxres']),
    );
  }
}