import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../constains.dart';
import 'home_page.dart';

class youtubeplayerListPage extends StatefulWidget {
  String url,titre,image,desc;
  var data;
  YT_APIPlaylist ytResult;
  youtubeplayerListPage({Key key,this.url,this.titre,this.image,this.desc,this.data,this.ytResult}) : super(key: key);

  @override
  _youtubeplayerListPageState createState() => _youtubeplayerListPageState();
}

class _youtubeplayerListPageState extends State<youtubeplayerListPage> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  List<PlayListItem> videos = new List();
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  var data;
  String uri,tite;
  var logger = Logger();
  List<YT_APIPlaylist> ytResultPlaylist = [];
  Future<List> getData() async {
    final response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId="+widget.ytResult.id+"&maxResults=10&key=AIzaSyC3Oj2o7fWNXEGcGIkiqVQPTRPVnzI43Wo"));
    data = json.decode(response.body);
    //this.videos.addAll(data["items"]);
    //logger.i(data["items"]==null?0:data["items"].length);

    //logger.i(data["items"][1]["snippet"]["title"]);
   // logger.i(data["items"]);

    setState(() {
    });

    return data["items"];
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //logger.i(widget.image);

    _controller = YoutubePlayerController(
      initialVideoId: widget.url.replaceAll("https://www.youtube.com/watch?v=", ""),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    _playerState = PlayerState.unknown;
    tite = widget.titre;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;

      });
    }
    //uri = widget.url;
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: colorPrimary),
          title: Image.asset("assets/images/1.png"),

        ),
        body: Container(
          decoration: BoxDecoration(
            color: bg,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                //padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 89,
                    ),

                    Container(
                      width: double.infinity,
                      child: player,
                    ),
                    card(),
                    SizedBox(
                      height: 10,
                    ),
                    videoSimilaire(),
                    Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 4,
                          children: List.generate(widget.data==null?0:widget.data["items"].length, (index) {
                            return Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      //uri =data["items"][index]["snippet"]["resourceId"]["videoId"];
                                      uri = widget.data["items"][index]["snippet"]["title"];

                                    });
                                    _controller.load(widget.data['items'][index]["snippet"]["resourceId"]["videoId"]);
                                    tite = widget.data["items"][index]["snippet"]["title"];

                                  },
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        child: widget.data["items"][index]["snippet"]["thumbnails"]["medium"]["url"] !=null?

                                        Container(
                                          width: 200,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${widget.data["items"][index]["snippet"]["thumbnails"]["medium"]["url"]}'),
                                                fit: BoxFit.cover),
                                          ),
                                        ):Container(),
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/jouer.png"))),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text(
                                      "${widget.data["items"][index]["snippet"]["title"]}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: colorPrimary),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget videoSimilaire() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 10.2),
          //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  "Vidéos Similaires",
                  style: TextStyle(
                    color: colorPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "helvetica",
                  ),
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }

  Widget card() {
    return Container(
      width: double.infinity,
      height: 40,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "${tite}",
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: "helvetica",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
