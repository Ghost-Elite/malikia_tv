
import '../youtube_api_v3.dart';

class Video{
  final String kind;
  final String etag;
  final String id;
  final SnippetVideo snippet;
  final ContentDetails contentDetails;
  final Status status;

  Video(this.kind,this.etag,this.id,this.snippet,this.contentDetails,this.status);
  factory Video.fromJson(Map<String,dynamic> json,Parts part){
    return Video(
      json['kind'],
      json['etag'],
      json['id'],
      part == Parts.snippet ? SnippetVideo.fromJson(json['snippet']) : null,
      part == Parts.contentDetails ? ContentDetails.fromJson(json['contentDetails']) : null,
      part == Parts.status ? Status.fromJson(json['status']) : null
    );
  }
}
