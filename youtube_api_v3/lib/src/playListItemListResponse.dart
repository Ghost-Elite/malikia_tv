import '../youtube_api_v3.dart';

class PlayListItemListResponse{
  final Map<String,dynamic> params;
  final String kind;
  final String etag;
  final String prevPageToken;
  final String nextPageToken;
  final PageInfo pageInfo;
  final List<PlayListItem> items;
  PlayListItemListResponse(this.params,this.kind,this.etag,this.prevPageToken,this.nextPageToken,this.pageInfo,this.items);

  prevPage(){
    if(prevPageToken == null)
      throw('No prev page!');
    params['pageToken'] = prevPageToken;
    return YoutubeAPIv3.playListItemsParams(params);
  }

  nextPage(){
    if(nextPageToken == null)
      throw('No next page!');
    params['pageToken'] = nextPageToken;
    return YoutubeAPIv3.playListItemsParams(params);
  }

  factory PlayListItemListResponse.fromJson(Map<String,dynamic> params,Map<String,dynamic> json){
    return PlayListItemListResponse(
      params,
      json['kind'],
      json['etag'],
      json['prevPageToken'],
      json['nextPageToken'],
      PageInfo.fromJson(json['pageInfo']),
      List<PlayListItem>.from(
        json['items'].map(
          (playListItem)=>
            PlayListItem.fromJson(playListItem,params['part'])
        ).toList()
      )
    );
  }
}