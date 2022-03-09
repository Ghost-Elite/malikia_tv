import 'package:flutter/material.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';



var apiKey = '';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Video{
  final String thumbnail;

  Video(this.thumbnail);
}

class _MyHomePageState extends State<MyHomePage> {

  List<PlayListItem> videos = new List();
  PlayListItemListResponse currentPage;

  @override
  void initState() {
    super.initState();
    getMusic();
  }

  setVideos(videos){
    setState(() {
      this.videos = videos;
    });
  }

  Future<List<PlayListItem>> getMusic() async{
    YoutubeAPIv3 api = new YoutubeAPIv3(apiKey);

    PlayListItemListResponse playlist = await api.playListItems(playlistId : 'PLTfigAbxBUNpoZ1OspADCabQ5meRDmPlP',maxResults:5,part:Parts.snippet);
    var videos = playlist.items.map((video){
        return video;
      }).toList();
    currentPage = playlist;
    this.videos.addAll(videos);
    setVideos(this.videos);
  }

  Future<List<PlayListItem>> nextPage() async{
    PlayListItemListResponse playlist = await currentPage.nextPage();
    var videos = playlist.items.map((video){
        return video;
      }).toList();
    currentPage = playlist;
    this.videos.addAll(videos);
    setVideos(this.videos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
              itemCount: videos.length + 1,
              itemBuilder: (BuildContext context,int index){
                if(videos.length == index){
                  return RaisedButton(
                    onPressed: (){
                      nextPage();
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text('Load More',style: TextStyle(color: Colors.white),),
                  );
                }
                var video = videos[index];
                return Card(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children:<Widget>[
                      Text(video.snippet.title),
                        Image(
                          fit: BoxFit.fitWidth,
                          image:NetworkImage(video.snippet.thumbnails.medium.url)
                        ),
                        ]
                  )
                );
              },
            )
      ),
    );
  }
}
