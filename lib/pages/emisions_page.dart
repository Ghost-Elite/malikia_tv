import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../animation/fadeanimation.dart';
import '../network/model/api_list_by_groupe.dart';
import 'home_page.dart';
import 'lecteur_emisions.dart';



class EmisionsPage extends StatefulWidget {

  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;

  EmisionsPage({Key key, this.lien, this.test, listChannelsbygroup})
      : super(key: key);

  @override
  _EmisionsPageState createState() => _EmisionsPageState();
}

class _EmisionsPageState extends State<EmisionsPage> {
  String query;
  TextEditingController nameController = TextEditingController();
  bool textField;

  String videoId, title, time,api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;


  Future<ListChannelsbygroup> fetchReplay() async {
    var postListUrl = Uri.parse(widget.lien);

    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //logger.d(data);
      // print(widget.listChanel.allitems[0].feedUrl);

      return ListChannelsbygroup.fromJson(jsonDecode(response.body));

    } else {
      throw Exception();
    }
  }
  /*Future<ListItemsByChannel> fetchEmission() async {
    var postListUrl =
    Uri.parse("https://7tv.acangroup.org//myapi//listItemsByChannel//79");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      //final data = jsonDecode(response.body);
      return ListItemsByChannel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }*/

  @override
  void initState() {
    this.textField = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: wite,
          title: Image.asset("assets/images/1.png"),
          iconTheme: IconThemeData(color: gren,),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bg,
          child: _buildCard(),
        ));
  }

  Widget _buildCard(){
    return Container(
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
                              //logger.d(snapshot.data.allitems[index].video_url);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LecteurDesReplayes(
                                        json: snapshot.data.allitems[index].videoUrl,
                                        related: snapshot.data.allitems[index].relatedItems,
                                        texte: snapshot.data.allitems[index].title,
                                        descpt: snapshot.data.allitems[index].desc,
                                        heure: snapshot.data.allitems[index].time,
                                        tpe: snapshot.data.allitems[index].type,
                                        vido_url: snapshot.data.allitems[index].feedUrl,
                                        listChannelsbygroup: snapshot.data,
                                      )
                                  ),
                                      (Route<dynamic> route) => true);
                              var  logger = Logger();
                              logger.d(snapshot.data.allitems[index].relatedItems);
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
    );
  }
}