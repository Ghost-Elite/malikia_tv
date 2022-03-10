import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:malikia_tv/pages/politique_page.dart';
import 'package:malikia_tv/pages/replay_page.dart';
import 'package:malikia_tv/pages/youtubeVideoPlaylist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import '../configs/size_config.dart';
import '../network/model/api_list_by_groupe.dart';
import '../network/model/api_malikia.dart';
import '../network/model/direct_api.dart';
import '../network/model/live_api.dart';
import 'AllPlayListScreen.dart';
import 'YoutubeChannelScreen.dart';
import 'description_page.dart';
import 'home_page.dart';
import 'lecteur_malikia.dart';


final String assetIcons1 = 'assets/images/facebook.svg';
final String assetIcons2 = 'assets/images/info.svg';
final String assetIcons3 = 'assets/images/lock.svg';
final String assetIcons4 = 'assets/images/notification.svg';
final String assetIcons5 = 'assets/images/replay.svg';
final String assetIcons6 = 'assets/images/tv.svg';
final String assetIcons7 = 'assets/images/youtube.svg';

class DrawerPage extends StatefulWidget {
  LiveApi liveApi;
  Direct direct;
  Apimalikia apimalikia;
  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;
  List<YT_API> ytResult = [];
  YoutubeAPI ytApi;
  List<YT_APIPlaylist> ytResultPlaylist = [];
  var logger = Logger();
  BetterPlayerController betterPlayerController;
  DrawerPage({Key key,this.logger, this.liveApi,this.betterPlayerController,this.direct,this.apimalikia,this.ytResult,this.ytApi,this.lien,this.listChannelsbygroup,this.test,this.ytResultPlaylist})
      : super(key: key);
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with SingleTickerProviderStateMixin {
  Direct direct;
  String lien;
  BetterPlayerController betterPlayerController;
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  Apimalikia  apimalikia;
  //String title;
  //String query = "JoyNews";
  String API_Key = 'AIzaSyA6qu7Yw62GjwAsCyviSKnUsWZ3od9-6uk';
  String API_CHANEL = 'UC0V1TlLFybhr0MJzxxXgdWw';
  var logger = Logger();
  Future<void> callAPI() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResult = await ytApi.channel(API_CHANEL);
    setState(() {
      print('UI Updated');
      isLoading = false;
      callAPIPlaylist();
    });
  }

  Future<void> callAPIPlaylist() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist.playlist(API_CHANEL);
    setState(() {
      print('UI Updated');
      print(ytResultPlaylist[0].title);
      isLoadingPlaylist = false;
    });
  }

  Future<Direct> fetchListAndroid() async {
    try {
      var postListUrl =
      Uri.parse("https://acanvod.acan.group/myapiv2/listLiveTV/walfvod/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data);
        setState(() {
          direct = Direct.fromJson(jsonDecode(response.body));
          //print(leral);

        });


      }
    } catch (error, stacktrace) {
      return Direct.withError("Data not found / Connection issue");
    }


  }

  Future<void> fetchList() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/appdetails/malikia");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //logger.w(listChannelsbygroup);
      apimalikia = Apimalikia.fromJson(data);

      logger.i("actu url",apimalikia.aCANAPI[0].appDataToload);
      setState(() {
        apimalikia.aCANAPI;
      });

      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
  @override
  void initState() {
    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 9, type: "playlist");
    //callAPI();
    fetchList();
    fetchListAndroid();
    logger.i('message ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/drawer.png"), fit: BoxFit.fill),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          children: <Widget>[
            DrawerHeader(child: Image.asset("assets/images/2.png",fit: BoxFit.cover,)),
            SizedBox(height: SizeConfi.screenHeight/15),
            ListTile(
              onTap: () {
                var logger = Logger();
                logger.i(' ghost-elite ',widget.apimalikia);
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => HomePage(
                  apimalikia: widget.apimalikia,
                  ytApi: widget.ytApi,
                  listChannelsbygroup: widget.listChannelsbygroup,
                  direct: widget.direct,
                  ytResult: widget.ytResult,
                  ytResultPlaylist: widget.ytResultPlaylist,
                )
                ));
              },
              leading: SvgPicture.asset(
                assetIcons6,
                width: 30,
                height: 30,

              ),
              title: Text(
                "Direct",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                logger.i('5677',widget.apimalikia);
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ReplyerPage(
                  apimalikia: apimalikia,
                  ytApi: widget.ytApi,
                  listChannelsbygroup: widget.listChannelsbygroup,
                  direct: widget.direct,
                  ytResult: widget.ytResult,
                  ytResultPlaylist: widget.ytResultPlaylist,

                )
                ));

                },

              leading: SvgPicture.asset(
                assetIcons5,
                width: 30,
                height: 30,

              ),
              title: Text(
                "Replay TV",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 15,),
            ListTile(
              /*onTap: (){
                const url ="https://youtube.com/c/7TVSénégal";
                launchURL(url);
              },*/
              onTap: () {
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => YoutubeVideoPlayList(

                )
                ));
              },
              leading: SvgPicture.asset(
                assetIcons7,
                width: 30,
                height: 30,
                color: Colors.black,
              ),
              title: Text(
                "YouTube",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: SizeConfi.screenHeight/18,),
            ListTile(

             onTap: (){
               if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
               _launchURL();
             },
              leading: SvgPicture.asset(
                assetIcons1,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              title: Text(
                "Facebook",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15,),
            ListTile(
              onTap: () {
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PolitiquePage(),
                    )
                );
              },
              leading: SvgPicture.asset(
                assetIcons3,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              title: Text(
                "Politique de confidentialité",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15,),
            ListTile(
              onTap: () {
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DescriptionPage()
                    )
                );
              },
              leading: SvgPicture.asset(
                assetIcons2,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              title: Text(
                "A propos",
                style: TextStyle(color: Colors.white),
              ),
            ),
           /* SizedBox(height: 50,),
            ListTile(
              title: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Website",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
  void _launchURL() async =>
      await canLaunch(widget.apimalikia.aCANAPI[0].appFbUrl) ? await launch(widget.apimalikia.aCANAPI[0].appFbUrl) : throw 'Could not launch ${widget.apimalikia.aCANAPI[0].appFbUrl}';

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
