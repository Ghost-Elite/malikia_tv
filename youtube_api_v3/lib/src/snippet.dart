import '../youtube_api_v3.dart';

class Snippet{
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;
  final String playlistId;
  final int position;
  final ResourceId resourceId;

  Snippet(this.publishedAt,this.channelId,this.title,this.description,this.thumbnails,this.channelTitle,this.playlistId,this.position,this.resourceId);
  factory Snippet.fromJson(Map<String,dynamic> json){
    return Snippet(
      json['publishedAt'],
      json['channelId'],
      json['title'],
      json['description'],
      Thumbnails.fromJson(json['thumbnails']),
      json['channelTitle'],
      json['playlistId'],
      json['position'],
      ResourceId.fromJson(json['resourceId'])
    );
  }
}

class SnippetVideo{
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;

  SnippetVideo(this.publishedAt,this.channelId,this.title,this.description,this.thumbnails,this.channelTitle);
  factory SnippetVideo.fromJson(Map<String,dynamic> json){
    return SnippetVideo(
      json['publishedAt'],
      json['channelId'],
      json['title'],
      json['description'],
      Thumbnails.fromJson(json['thumbnails']),
      json['channelTitle']
    );
  }
}