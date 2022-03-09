import 'dart:convert';
import 'package:better_player/better_player.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';

import '../animation/fadeanimation.dart';
import '../constains.dart';
import '../network/model/api_list_by_groupe.dart';
import '../network/model/api_malikia.dart';
import '../network/model/direct_api.dart';
import '../network/model/live_api.dart';
import 'AllPlayListScreen.dart';
import 'emisions_page.dart';
import 'home_page.dart';


class ReplyerPage extends StatefulWidget {
  LiveApi liveApi;
  Direct direct;
  Apimalikia apimalikia;
  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;
  List<YT_API> ytResult = [];
  YoutubeAPI ytApi;
  List<YT_APIPlaylist> ytResultPlaylist = [];

  BetterPlayerController betterPlayerController;

  ReplyerPage({Key key,this.apimalikia,this.ytResultPlaylist,this.direct,this.ytResult,this.listChannelsbygroup,this.ytApi,this.liveApi,this.test,this.lien,this.betterPlayerController}) : super(key: key);

  @override
  _ReplyerPageState createState() => _ReplyerPageState();
}

class _ReplyerPageState extends State<ReplyerPage> {
  dynamic data;
  var loading = false;
  String url, time,test,lien,logo,videoId, title, titre;
  bool isVideoLoading = true;
  bool isPlay = false;
  bool isVisible = false;
  ListChannelsbygroup listChannelsbygroup;
  var logger = Logger();
  String query;
  TextEditingController nameController = TextEditingController();

  bool textField;

  Future<ListChannelsbygroup> fetchReplay() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/listChannelsByChaine/malikia/44/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return ListChannelsbygroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    this.textField = false;
    logger.i('2022',widget.apimalikia);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       appBar: AppBar(
         backgroundColor: wite,
         elevation: 0,
         centerTitle: true,
         iconTheme: IconThemeData(color: colorPrimary),
         leading: IconButton(
           icon: Icon(
             Icons.arrow_back,
             color: colorPrimary,
           ),
           onPressed: (){
             Navigator.of(context).pop();
           },
         ),
         title: Image.asset(
           "assets/images/1.png",
         ),
       ),
        body: Container(
          width: MediaQuery.of(context).size.width,

          color: bg,
          child: _buildCard(),
        )
    );
  }


  Widget _buildCard(){
    return widget.apimalikia.aCANAPI[0].appDataToload =='vod'? Container(
      width: MediaQuery.of(context).size.width,
      child:ConstrainedBox(
        constraints: BoxConstraints(),
        child:  FutureBuilder(
            future: fetchReplay(),
            builder: (context,snapshot){
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: gren,
                  ),
                );
              } else
                return GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2 ,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                  children: List.generate(snapshot.data.allitems.length,(index){
                    return Column(
                      children: [
                        GestureDetector(
                            child: FadeAnimation(
                                0.5,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(

                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.allitems[index].logo,width: 100,height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        "assets/images/malikiaError.png",width: 150,
                                        fit: BoxFit.contain,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        "assets/images/malikiaError.png",width: 150,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                  ),
                                )
                            ),
                            onTap: () {
                              print(snapshot.data.allitems[index].feedUrl);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EmisionsPage(
                                      //test: snapshot.data.allitems[index].feedUrl,
                                      lien: snapshot.data.allitems[index].feedUrl,
                                      listChannelsbygroup: snapshot.data,
                                    )
                                ),
                              );
                            }
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text("${snapshot.data.allitems[index].title}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: gren
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                );
            }
        ),
      ),
    ):
    Container(
      width: MediaQuery.of(context).size.width,
      child:ConstrainedBox(
        constraints: BoxConstraints(),
        child:  GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2 ,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          children: List.generate(widget.ytResultPlaylist.length>0?widget.ytResultPlaylist.length:0,(index){
            return Column(
              children: [
                GestureDetector(
                    child: FadeAnimation(
                        0.5,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(

                            child: widget.ytResultPlaylist[index] !=null?
                            CachedNetworkImage(
                              imageUrl: widget.ytResultPlaylist[index].thumbnail['high']['url'],width: 100,height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/malikiaError.png",width: 150,
                                fit: BoxFit.contain,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/malikiaError.png",width: 150,
                                fit: BoxFit.contain,
                              ),
                            ):Container(),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                          ),
                        )
                    ),
                    onTap: () {
                      logger.wtf('Ghost-Elite 2022',widget.ytResultPlaylist);
                      if(widget.ytResultPlaylist[index] !=null && widget.ytResultPlaylist[index]!=0){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllPlayListScreen(
                                      ytResult: widget.ytResultPlaylist[index],
                                      //apikey: widget.API_Key,
                                    )),
                                (Route<dynamic> route) => true);
                      }else{
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    PageVide(

                                      //apikey: widget.API_Key,
                                    )),
                                (Route<dynamic> route) => true);
                      }

                    }
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text("${widget.ytResultPlaylist[index].title}",
                      style: TextStyle(
                          fontSize: 14,
                          color: gren
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

              ],
            );
          }),
        ),
      ),
    );
  }

}
class PageVide extends StatefulWidget {
  const PageVide({Key key}) : super(key: key);

  @override
  _PageVideState createState() => _PageVideState();
}

class _PageVideState extends State<PageVide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}


