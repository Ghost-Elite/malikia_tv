
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malikia_tv/pages/ytoubeplayer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:http/http.dart' as http;
import '../constains.dart';
import '../network/model/api_malikia.dart';
import '../network/model/direct_api.dart';
import 'AllPlayListScreen.dart';
import 'home_page.dart';




class YoutubeChannelScreen extends StatefulWidget {
  final String apiKey,channelId;

  YT_APIPlaylist ytResult;
  YoutubeChannelScreen({Key key,this.apiKey, this.channelId,this.ytResult, String apikey}) : super(key: key);

  @override
  _YoutubeChannelScreenState createState() => _YoutubeChannelScreenState();
}

class _YoutubeChannelScreenState extends State<YoutubeChannelScreen> with AutomaticKeepAliveClientMixin<YoutubeChannelScreen>{
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  String lien;
  bool isLoadingPlaylist = true;
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UC0V1TlLFybhr0MJzxxXgdWw';
  Direct direct;
  Apimalikia apimalikia;
  Color bg = const Color(0xFFEBEBEB);
  Future<Apimalikia> fetchYoutube() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/appdetails/albayanetv");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //logger.w(listChannelsbygroup);
      apimalikia = Apimalikia.fromJson(jsonDecode(response.body));

      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
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
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    //print('hello');
  }
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return new Scaffold(

        appBar: AppBar(
          backgroundColor: wite,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: gren,),
          title: Image.asset(
            "assets/images/1.png",
          ),

        ),
      body: new Container(
       color: bg,
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: callAPI,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        makeItemVideos(),
                      ],
                    ),
                  ),
                  /* SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    delegate: SliverChildListDelegate(
                      [
                        Container(

                          child: isLoadingPlaylist
                              ? Center(
                            child: makeShimmerEmissions(),
                            //child: CircularProgressIndicator(),
                          )
                              : makeItemEmissions(),
                        ),
                      ]
                    ),
                  )*/
                ],
              )
          )
      ),
    );


      /*Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/exit.png"))),
          ),
        ),
        actions: [
          Container(
            width: 150,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/LOGO.png")
                )
            ),
          ),
          GestureDetector(
            *//*onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => RadioPlayerScreen(
                      radioApi: widget.radioApi,
                    )
                ),
              );
              //logger.d(snapshot.data.allitems[i].relatedItems);
            },*//*
            child: Container(
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/radio_albayane.png")
                  )
              ),
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: callAPI,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/ALBAYANE4.png",
                ),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/ALBAYANE4.png"),
                      fit: BoxFit.cover
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        child: Text("La chaine de l'islame éternel pour l'éternité",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Great Vibes",
                              fontWeight: FontWeight.normal,
                              color: Palette.colorSecondary),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: makeVideos()
                    )
                  ],
                ),
              ),

            ],
          ),
        ),

      )
    );*/
  }

  Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => YtoubePlayerPage(
                      videoId: ytResult[position].url,
                      title: ytResult[position].title,

                      ytResult: ytResult,
                    )),
                    (Route<dynamic> route) => true);
          },
          child: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [

                          CachedNetworkImage(
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            imageUrl:  ytResult[position].thumbnail['medium']
                            ['url'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/malikiaError.png",
                              fit: BoxFit.contain,
                              height: 120,
                              width: 120,
                              //color: colorPrimary,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/malikiaError.png",
                              fit: BoxFit.contain,
                              height: 120,
                              width: 120,
                              //color: colorPrimary,
                            ),
                          ),

                        ],
                      ),
                      Container(
                        child: Flexible(
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 70,
                              padding: EdgeInsets.all(5),
                              child: Text(
                                ytResult[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: colorPrimary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned.fill(
                bottom: 60,
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/jouer.png"))),
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: ytResult.length,
    );
  }



  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {

        return GestureDetector(
          onTap: () {

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => AllPlayListScreen(
                    ytResult: ytResultPlaylist[position],
                    apikey:API_Key,

                  )),
                  (Route<dynamic> route) => true,);
          },
          child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,

              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      //alignment: Alignment.center,
                      child: new Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: ytResultPlaylist[position].thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    "assets/images/malikiaError.png",
                                  ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/malikiaError.png",
                                  ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                ytResultPlaylist[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount: 5,
    );
  }




  traitWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: 3,
            width: 400,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
  Widget makeVideos(){
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.all(8),
      crossAxisSpacing: 8,
      mainAxisSpacing: 5,
      children: List.generate(ytResult.length, (index) {
        return Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage('${ytResult[index]
                                .thumbnail["medium"]["url"]}'),
                            fit: BoxFit.cover
                        ),

                      ),
                      /*child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "${model.allitems[index].logo}",width: 250,height: 160,),
              ),*/
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/play_button.png")
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                /*onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => YoutubeVideoPlayer(
                            url: ytResult[index].url,
                            title: ytResult[index].title,
                            img: ytResult[index].thumbnail['medium']['url'],
                            related: "",
                            ytResult: ytResult,
                          )
                          )
                          ),*/
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              YtoubePlayerPage(
                                videoId: ytResult[index].url,
                                title: ytResult[index].title,

                                related: "",
                                ytResult: ytResult,
                              )),
                          (Route<dynamic> route) => true);
                }
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.fromLTRB(17, 0, 10, 0),
                child: Text("${ytResult[index].title}",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber
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
        children: List.generate(ytResultPlaylist==null?0:ytResultPlaylist.length,(index){
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPlayListScreen(
                              ytResult: ytResultPlaylist[index],
                              apikey:API_Key,


                            ),

                      ),
                          (Route<dynamic> route) => true);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: ytResultPlaylist[index].thumbnail['high']['url'],width: 100,height: 100,
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
                  child: Text("${ytResultPlaylist[index].title}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }
        ),
      )
    );
  }

}


