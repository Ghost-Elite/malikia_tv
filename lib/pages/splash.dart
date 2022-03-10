import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/youtube_api.dart';

import '../network/model/api_malikia.dart';
import '../network/model/direct_api.dart';
import '../network/model/list_android.dart';
import 'home_page.dart';





class SplashScreen extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  final logger = Logger();
  bool isLoading = false;
  dynamic error;
  Apimalikia  apimalikia;
  ListAndroid listAndroid;
  Direct direct;


  Future<Apimalikia> fetchMalikia() async {
    try {
      await EasyLoading.show();
      var postListUrl =
      Uri.parse("https://tveapi.acan.group/myapiv2/appdetails/malikia/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        setState(() {
          apimalikia = Apimalikia.fromJson(jsonDecode(response.body));
          //print(leral);
        });
        await EasyLoading.dismiss();

        //print(leral.allitems[0].mesg);
        navigationPage();
      }
    } catch (error, stacktrace) {
      internetProblem();
      return Apimalikia.withError("Data not found / Connection issue");
    }


  }
  Future<void> testUrl() async {
    try {
      String url =
          "https://acanvod.acan.group/myapiv2/appdetails/malikia";
      final response = await http.get(Uri.parse(url));
      print(response.body);

      Apimalikia apimalikia = Apimalikia.fromJson(jsonDecode(response.body));
      logger.w(apimalikia.aCANAPI[0].appDataToload);

      /*if (apimalikia.aCANAPI[0].appDataToload == "youtube") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              Malikiatv_HomePage(
                apimalikia: apimalikia,
              ),
          ),
              (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              HomePage(
                apimalikia: apimalikia,
                direct: direct,
              ),
          ),
              (Route<dynamic> route) => false,
        );
      }*/
    } catch (error, stacktrace) {

      return Apimalikia.withError("Data not found / Connection issue");
    }

  }
  Future<Direct> fetchListAndroid() async {
    try {
      var postListUrl =
      Uri.parse("https://acanvod.acan.group/myapiv2/listLiveTV/malikia/json");
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
      internetProblem();
      return Direct.withError("Data not found / Connection issue");
    }


  }
  Future<void> _refreshProducts(BuildContext context) async {
    return fetchMalikia();
  }
  Future<bool> internetProblem() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: new Text('Malikia TV',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                fontFamily: "CeraPro",
                fontWeight: FontWeight.bold,
                color: Color(0xFF00722f))),
        content: new Text(
          "Problème d\'accès à Internet, veuillez vérifier votre connexion et réessayez !!!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontFamily: "CeraPro",
              fontWeight: FontWeight.normal,
              color: Color(0xFF00722f)),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SplashScreen()));
                },
                child: Container(
                  width: 120,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00722f), Color(0xFF0148BA5)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(35)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "CeraPro",
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) ??
        false;
  }

  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  String lien;
  bool isLoadingPlaylist = true;
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UC0V1TlLFybhr0MJzxxXgdWw';
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
  @override
  void initState(){
    //testUrl();
    //fetchListAndroid();
    super.initState();
    startTime();
    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    fetchListAndroid();
    //logger.i('message',ytResult[0].title);
    //fetchDirect();

  }
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, fetchMalikia);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //var assetsImage = new AssetImage('assets/images/logo.png');
    var assetsBg = new AssetImage(
        'assets/images/splash.png',);
    //var assetsBgLogo = new AssetImage('assets/images/bglogo.png');
    //var image = new Image(image: assetsImage, height: 100);
    //var bgLogo = new Image(image: assetsBgLogo, height: 100);
    var bg = new Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splash.png"),
              fit: BoxFit.cover
            ),
          ),
        ),
        /*Positioned(
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
          child: Text('Website'),
        ),
        )*/
      ],
    ); //<- Creates a widget that displays an image.

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          bg,
          new Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Platform.isIOS?200:300,),
                  /* Container(
                    width: 300,
                    child:image
                ),
                Container(
                    height: Platform.isIOS?300:400,
                    width: Platform.isIOS?300:400,
                    child:bgLogo
                )*/
                ],
              )
          )
        ]), //<- place where the image appears
      ),
    );
  }

  Future<void> navigationPage() async {
    logger.wtf('test ms',apimalikia.aCANAPI[0].appDataToload);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(
          //apimalikia: apimalikia,
          direct: direct,
          ytApi: ytApi,
          ytResult: ytResult,
          ytResultPlaylist: ytResultPlaylist,
          apimalikia: apimalikia,
        ),
        ),
            (Route<dynamic> route) => false,
      );
    }

}
