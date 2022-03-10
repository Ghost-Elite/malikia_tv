import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:malikia_tv/pages/ytoubeplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_api/yt_video.dart';

import '../network/model/alauneByGroup.dart';
import '../network/model/api_malikia.dart';
import 'chaine_page.dart';
import 'home_page.dart';

class PlusPage extends StatefulWidget {
  VideoPlayerController playerController;
  ChewieController chewieController;
  List<YT_API> ytResult = [];
  YoutubeAPI ytApi;
  List<YT_APIPlaylist> ytResultPlaylist = [];
  Apimalikia apimalikia;
  PlusPage({Key key,this.playerController,this.chewieController,this.ytResultPlaylist,this.ytResult,this.ytApi,this.apimalikia}): super(key: key);
  @override
  _PlusPageState createState() => _PlusPageState();
}

class _PlusPageState extends State<PlusPage> {
  String videoId, title, time,api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  AlauneByGroup alauneByGroup;
  var logger = Logger();
  Future<AlauneByGroup> fetchAlauneByGroupe() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/alauneByGroup/malikia/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);


      //logger.w(listChannelsbygroup);
      return AlauneByGroup.fromJson(jsonDecode(response.body));


      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    super.initState();
    logger.i('message',widget.apimalikia);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: wite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: gren,),
        title: Image.asset(
          "assets/images/1.png",
        ),

      ),
      body: Container(
        color: wite,

        child: _buildCard(),
      ),
    );
  }


  Widget _buildCard(){
    return widget.apimalikia.aCANAPI[0].appDataToload =='vod'? Container(
      child:ConstrainedBox(
        constraints: BoxConstraints(),
        child:  FutureBuilder(
            future: fetchAlauneByGroupe(),
            builder: (context,snapshot){
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: gren,
                  ),
                );
              } else
                return ListView.builder(
                    itemCount: snapshot.data.allitems.length,
                    itemBuilder: (_, i) {
                      return Card(
                        //semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shadowColor: Colors.black,
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: 250,
                                height: 250,
                                color: Colors.white,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("${snapshot.data.allitems[i].logo}"),
                                    fit: BoxFit.cover
                                  )
                                ),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.bottomCenter,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage("assets/images/wave.png"),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                        child: Text(
                                          "${snapshot.data.allitems[i].title}",
                                          style: TextStyle(color: Colors.white, fontSize: 13),
                                          maxLines: 1,
                                        ),
                                      ),
                                        onTap: () {
                                          //logger.d(snapshot.data.allitems[index].video_url);
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => LecteurDesReplayesEmisions(
                                                    json: snapshot.data.allitems[i].videoUrl,
                                                    //related: snapshot.data.allitems[i].relatedItems,
                                                    texte: snapshot.data.allitems[i].title,
                                                    descpt: snapshot.data.allitems[i].desc,
                                                    heure: snapshot.data.allitems[i].time,
                                                    tpe: snapshot.data.allitems[i].type,
                                                    vido_url: snapshot.data.allitems[i].feedUrl,
                                                    AlauneByGroup: snapshot.data,
                                                  )
                                              ),
                                                  (Route<dynamic> route) => true);
                                          var  logger = Logger();
                                          logger.d(snapshot.data.allitems[i].feedUrl);
                                        }
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: InkWell(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(60),
                                                color: wite,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 0,
                                                      offset: Offset(0, 0),
                                                      color: Colors.grey.withOpacity(0.2)),
                                                ]
                                            ),
                                            child: Icon(
                                              Icons.play_circle,
                                              color: gren,
                                              size: 60,

                                            ),
                                          ),
                                            onTap: () {
                                              //logger.d(snapshot.data.allitems[index].video_url);
                                              Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) => LecteurDesReplayesEmisions(
                                                        json: snapshot.data.allitems[i].videoUrl,
                                                        //related: snapshot.data.allitems[i].relatedItems,
                                                        texte: snapshot.data.allitems[i].title,
                                                        descpt: snapshot.data.allitems[i].desc,
                                                        heure: snapshot.data.allitems[i].time,
                                                        tpe: snapshot.data.allitems[i].type,
                                                        vido_url: snapshot.data.allitems[i].feedUrl,
                                                        AlauneByGroup: snapshot.data,
                                                      )
                                                  ),
                                                      (Route<dynamic> route) => true);
                                              var  logger = Logger();
                                              logger.d(snapshot.data.allitems[i].feedUrl);
                                            }
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              /*Container(
                                padding: const EdgeInsets.all(5.0),
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("${snapshot.data.allitems[i].logo}"),
                                    fit: BoxFit.cover
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Colors.black.withAlpha(0),
                                      Colors.lightGreenAccent,
                                      Colors.black45
                                    ],
                                  ),
                                ),
                                child:  Text(
                                  "${snapshot.data.allitems[i].title}",
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                              )*/
                            ],
                          ),
                        ),

                        /*GestureDetector(
                          child: FadeAnimation(
                              0.5,
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(0),
                                child: Container(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data.allitems[i].logo,
                                    width: 200,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          "assets/images/2.png",
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.contain,

                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                        Image.asset(
                                          "assets/images/2.png",
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                  ),
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  height: 200,
                                ),
                              )),
                        )*/

                        elevation: 5,
                        margin: EdgeInsets.all(10),

                      );
                    });
            }
        ),
      ),
    ):Container(
      child:ConstrainedBox(
        constraints: BoxConstraints(),
        child:  ListView.builder(
            itemCount: widget.ytResult.length>24?24:widget.ytResult.length,
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              YtoubePlayerPage(
                                videoId: widget.ytResult[i].url,
                                title: widget.ytResult[i].title,

                                related: "",
                                ytResult: widget.ytResult,
                              )),
                          (Route<dynamic> route) => true);
                },
                child: Card(
                  //semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 250,
                          height: 250,
                          color: Colors.white,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage("${widget.ytResult[i]
                                      .thumbnail["medium"]["url"]}"),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Stack(
                            children: [
                              GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage("assets/images/wave.png"),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                    child: Text(
                                      "${widget.ytResult[i].title}",
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                      maxLines: 1,
                                    ),
                                  ),
                                  onTap: () {
                                    //logger.d(snapshot.data.allitems[index].video_url);


                                  }
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: InkWell(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(60),
                                            color: wite,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 0,
                                                  offset: Offset(0, 0),
                                                  color: Colors.grey.withOpacity(0.2)),
                                            ]
                                        ),
                                        child: Icon(
                                          Icons.play_circle,
                                          color: gren,
                                          size: 60,

                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    YtoubePlayerPage(
                                                      videoId: widget.ytResult[i].url,
                                                      title: widget.ytResult[i].title,

                                                      related: "",
                                                      ytResult: widget.ytResult,
                                                    )),
                                                (Route<dynamic> route) => true);

                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        /*Container(
                                  padding: const EdgeInsets.all(5.0),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("${snapshot.data.allitems[i].logo}"),
                                      fit: BoxFit.cover
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Colors.black.withAlpha(0),
                                        Colors.lightGreenAccent,
                                        Colors.black45
                                      ],
                                    ),
                                  ),
                                  child:  Text(
                                    "${snapshot.data.allitems[i].title}",
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  ),
                                )*/
                      ],
                    ),
                  ),

                  /*GestureDetector(
                            child: FadeAnimation(
                                0.5,
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(0),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data.allitems[i].logo,
                                      width: 200,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            "assets/images/2.png",
                                            width: 200,
                                            height: 100,
                                            fit: BoxFit.contain,

                                          ),
                                      errorWidget:
                                          (context, url, error) =>
                                          Image.asset(
                                            "assets/images/2.png",
                                            width: 200,
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                    ),
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    height: 200,
                                  ),
                                )),
                          )*/

                  elevation: 5,
                  margin: EdgeInsets.all(10),

                ),
              );
            }),
      ),
    );
  }
}