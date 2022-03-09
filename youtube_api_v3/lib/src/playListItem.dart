
import '../youtube_api_v3.dart';

class PlayListItem{
  final String kind;
  final String etag;
  final String id;
  final Snippet snippet;
  final ContentDetails contentDetails;
  final Status status;

  PlayListItem(this.kind,this.etag,this.id,this.snippet,this.contentDetails,this.status);
  factory PlayListItem.fromJson(Map<String,dynamic> json,Parts part){
    return PlayListItem(
      json['kind'],
      json['etag'],
      json['id'],
      part == Parts.snippet ? Snippet.fromJson(json['snippet']) : null,
      part == Parts.contentDetails ? ContentDetails.fromJson(json['contentDetails']) : null,
      part == Parts.status ? Status.fromJson(json['status']) : null
    );
  }
}
