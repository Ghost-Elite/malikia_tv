import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constains.dart';
import 'AllPlayListScreen.dart';
import 'home_page.dart';

class YoutubeEmisionPage extends StatefulWidget {
  List<YT_APIPlaylist> ytResultPlaylist;
  YoutubeEmisionPage({Key key, this.ytResultPlaylist}) : super(key: key);

  @override
  _YoutubeEmisionPageState createState() => _YoutubeEmisionPageState();
}

class _YoutubeEmisionPageState extends State<YoutubeEmisionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: wite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: colorPrimary),
        leading: IconButton(
          icon: const Icon(
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
      body: SingleChildScrollView(
        child: makeItemEmissions(),
      ),
    );

  }
  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AllPlayListScreen(
                    ytResult: widget.ytResultPlaylist[position],
                    //apikey: API_Key,
                  ),
                ),
                    (Route<dynamic> route) => true);
          },
          child: Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.ytResultPlaylist[position]
                                  .thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) => Image.asset(
                                  "assets/images/malikia.png",fit: BoxFit.cover
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/malikia.png",fit: BoxFit.cover
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                widget.ytResultPlaylist[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 13,
                                    color: colorPrimary),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.playlist_play,
                                  size: 25,
                                  color: colorPrimary,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount: widget.ytResultPlaylist == null ? 0 : widget.ytResultPlaylist.length,
    );
  }
}
