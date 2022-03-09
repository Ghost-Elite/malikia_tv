library youtube_api_v3;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../youtube_api_v3.dart';

class YoutubeAPIv3 {
  final String key;
  YoutubeAPIv3(this.key);

  static String linkFromParams(Map<String,dynamic> params){
    return params.keys.map((key){
      if(params[key] is Parts){
        String partValue = params[key].toString().split('.').last;
        return '$key=$partValue';
      }
      return '$key=${params[key]}';
    }).join('&');
  }

  Future<PlayListItemListResponse> playListItems({@required String playlistId,@required int maxResults,@required Parts part}){
    Map<String,dynamic> params = new Map();
    params['key'] = key;
    params['playlistId'] = playlistId;
    params['maxResults'] = maxResults;
    params['part'] = part;
    return playListItemsParams(params);
  }

  static Future<PlayListItemListResponse> playListItemsParams(Map<String,dynamic> params){
    log(linkFromParams(params));
    return
      get(Uri.parse('https://www.googleapis.com/youtube/v3/playlistItems?${linkFromParams(params)}'))
        .then((response)=>
          PlayListItemListResponse.fromJson(params,jsonDecode(response.body)));
  }

  Future<VideoListResponse> videos({@required String id,@required Parts part}){
    Map<String,dynamic> params = new Map();
    params['key'] = key;
    params['id'] = id;
    params['part'] = part;
    return videosParams(params);
  }

  static Future<VideoListResponse> videosParams(Map<String,dynamic> params){
    log(linkFromParams(params));
    return
      get(Uri.parse('https://www.googleapis.com/youtube/v3/videos?${linkFromParams(params)}'))
        .then((response){
          return VideoListResponse.fromJson(params,jsonDecode(response.body));});
  }
}