
import '../youtube_api_v3.dart';

class VideoListResponse{
  final Map<String,dynamic> params;
  final String kind;
  final String etag;
  final PageInfo pageInfo;
  final List<Video> items;
  VideoListResponse(this.params,this.kind,this.etag,this.pageInfo,this.items);

  factory VideoListResponse.fromJson(Map<String,dynamic> params,Map<String,dynamic> json){
    return VideoListResponse(
      params,
      json['kind'],
      json['etag'],
      PageInfo.fromJson(json['pageInfo']),
      List<Video>.from(
        json['items'].map(
          (video)=>
            Video.fromJson(video,params['part'])
        ).toList()
      )
    );
  }
}