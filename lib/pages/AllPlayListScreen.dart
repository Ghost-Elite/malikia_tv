import 'dart:convert';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:malikia_tv/pages/youtube_playerList.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:http/http.dart' as http;
import '../constains.dart';
import '../network/model/api_list_by_groupe.dart';
import '../network/model/api_malikia.dart';
import 'home_page.dart';

class AllPlayListScreen extends StatefulWidget {
  YT_APIPlaylist ytResult;
  ListChannelsbygroup listChannelsbygroup;
  Apimalikia apimalikia;
  var data;
  AllPlayListScreen({this.ytResult, String apikey,this.apimalikia,this.listChannelsbygroup,this.data});

  @override
  _AllPlayListState createState() => _AllPlayListState();
}

class _AllPlayListState extends State<AllPlayListScreen> {
  bool isLoading = true;
  var data;
  var logger = Logger();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  List<YT_APIPlaylist> ytResultPlaylist = [];

  Future<void> callAPI() async {
    /*print('UI callled');
    String query = "Dakaractu TV HD";

    ytResult = await ytApi.search(query);*/
    await Jiffy.locale("en");
    //ytResultPlaylist = widget.ytResult;
    setState(() {
      isLoading = false;
    });
  }
  Future<List> getData() async {
    final response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId="+widget.ytResult.id+"&maxResults=10&key=AIzaSyC3Oj2o7fWNXEGcGIkiqVQPTRPVnzI43Wo"));
    data = json.decode(response.body);
    //this.videos.addAll(data["items"]);
    //logger.i(data["items"]==null?0:data["items"].length);

    //logger.i(data["items"][1]["snippet"]["title"]);
    //logger.i(data["items"]);

    setState(() {
    });

    return data["items"];
  }

  @override
  void initState() {
    super.initState();
    getData();

    //callAPI();
  }

  @override
  Widget build(BuildContext context) {

    Wakelock.enable();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: wite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorPrimary),
        title: Image.asset("assets/images/1.png"),

      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            color: bg),
        child: Stack(
          children: [

            makeGridView()
          ],
        ),
      ),
    );
  }
  Widget makeGridView(){

    return Container(
      padding: EdgeInsets.fromLTRB(0, 95.0, 0, 0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(data==null?0:data["items"].length,(index){
          //print(data["items"]["snippet"][index]["thumbnails"]["maxres"]["url"]);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              youtubeplayerListPage(
                                url: data["items"][index]["snippet"]["resourceId"]["videoId"],
                                titre: data["items"][index]["snippet"]["title"],
                                image: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],
                                desc: data["items"][index]["snippet"]["title"],
                                //title: data["items"][index]["snippet"]["title"],

                                data: data,
                              )),
                          (Route<dynamic> route) => true);
                },
                child: Stack(
                  children: [
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(

                          child:data["items"] !=null?
                          CachedNetworkImage(
                            imageUrl: data["items"][index]["snippet"]["thumbnails"]["url"],width: 100,height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/malikiaError.png",width: 150,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/malikiaError.png",width: 150,
                              fit: BoxFit.cover,
                            ),
                          ): Container(),
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                        ),
                      ),

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
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("${data["items"][index]["snippet"]["title"]}",
                    style: TextStyle(
                        fontSize: 14,
                        color: colorPrimary
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }),
      )
      /*widget.apimalikia.aCANAPI[0].appDataToload == "youtube"?GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(data["items"]==null?0:data["items"].length,(index){
         print(data["items"]["snippet"][index]["thumbnails"]["maxres"]["url"]);
          return Column(
            children: [
              GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],width: 100,height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                ),

              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("${data["items"][index]["snippet"]["title"]}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Palette.color4
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }),
      ):GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(widget.listChannelsbygroup.allitems.length,(index){
          return Column(
            children: [
              GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: widget.listChannelsbygroup.allitems[index].logo,width: 100,height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                  ),
                ),

              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("${widget.listChannelsbygroup.allitems[index].title}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Palette.color4
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }),
      ),*/
    );
  }
}