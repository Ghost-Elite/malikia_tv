
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malikia_tv/pages/politique_page.dart';
import 'package:malikia_tv/pages/replay_page.dart';

import 'YoutubeChannelScreen.dart';
import 'description_page.dart';
import 'home_page.dart';

final String assetIcons1 = 'assets/images/facebook.svg';
final String assetIcons2 = 'assets/images/info.svg';
final String assetIcons3 = 'assets/images/lock.svg';
final String assetIcons5 = 'assets/images/replay.svg';
final String assetIcons7 = 'assets/images/youtube.svg';



class InkWellDrawer extends StatefulWidget {
  @override
  _InkWellDrawerState createState() => _InkWellDrawerState();
}

class _InkWellDrawerState extends State<InkWellDrawer> {
  @override
  Widget build(BuildContext ctxt) {
    return new Drawer(
      //elevation: 16.0,

      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/drawer.png"),
                fit: BoxFit.fill)),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/2.png"),fit: BoxFit.cover
                )),
              ),
            ),
            CustomListTile(Icons.tv,
                'TV',
                () => {
                      Navigator.pop(ctxt),
                      Navigator.pushAndRemoveUntil(
                          ctxt,
                          new MaterialPageRoute(
                              builder: (ctxt) => new HomePage()),(Route<dynamic> route) => true)
                    }),
            CustomListTile(Icons.replay_circle_filled,
                'Replay',
                () => {
                      Navigator.pop(ctxt),
                  Navigator.pushAndRemoveUntil(
                      ctxt,
                      new MaterialPageRoute(
                          builder: (ctxt) => new ReplyerPage()),(Route<dynamic> route) => true)
                    }),

            CustomListTile(Icons.youtube_searched_for,'Youtube', () => {
              Navigator.pop(ctxt),
              Navigator.pushReplacement(
                  ctxt,
                  new MaterialPageRoute(
                      builder: (ctxt) => new YoutubeChannelScreen()))
            }),

            SizedBox(
              height: 150,
            ),
            CustomList(Icons.play_arrow,
                'Facebook',
                () => {
                      Navigator.pop(ctxt),
                      Navigator.push(
                          ctxt,
                          new MaterialPageRoute(
                              builder: (ctxt) => new HomePage()))
                    }),
            CustomList(Icons.security,'Politique de confidentialité', () => {
              Navigator.pop(ctxt),
              Navigator.push(
                  ctxt,
                  new MaterialPageRoute(
                      builder: (ctxt) => new PolitiquePage()))
            }),
            CustomList(Icons.message,'A propos', () => {
              Navigator.pop(ctxt),
              Navigator.push(
                  ctxt,
                  new MaterialPageRoute(
                      builder: (ctxt) => new DescriptionPage()))
            }),

          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget{


  final IconData icon;
  final  String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context){
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child:Container(
        child: InkWell(
            onTap: onTap,
            child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment : MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(icon),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      Text(text, style: TextStyle(
                          fontSize: 16
                      ),),
                    ],),

                  ],)
            )
        ),
      ),
    );
  }
}

class CustomList extends StatelessWidget{

  final IconData icon;
  final  String text;
  final Function onTap;

  CustomList(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context){
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child:Container(
        child: InkWell(
            onTap: onTap,
            child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment : MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(icon,color: Color(0xFFf8fbf8),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      Text(text, style: TextStyle(
                          fontSize: 16,
                        color: Color(0xFFf8fbf8),
                      ),),
                    ],),

                  ],)
            )
        ),
      ),
    );
  }
}
