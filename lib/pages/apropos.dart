// /*
// import 'dart:convert';
//
// import 'package:api_malikia/network/model/api_list_by_groupe.dart';
// import 'package:api_malikia/network/model/api_malikia.dart';
// import 'package:api_malikia/network/model/description.dart';
// import 'package:api_malikia/pages/home_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:logger/logger.dart';
// import 'package:http/http.dart' as http;
//
// class AproposPage extends StatefulWidget {
//   Apimalikia  apimalikia;
//  AproposPage({Key key,this.apimalikia}) : super(key: key);
//
//   @override
//   _AproposPageState createState() => _AproposPageState();
// }
//
// class _AproposPageState extends State<AproposPage> {
//
//
//   Future<Description> fetchDescription() async {
//     try {
//       var postListUrl =
//       Uri.parse("https://acanvod.acan.group/myapiv2/appinfo/sentv/description/json");
//       final response = await http.get(postListUrl);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         var logger = Logger();
//         logger.w(data);
//
//          return Description.fromJson(jsonDecode(response.body));
//         //print(leral);
//
//       }
//     } catch (error, stacktrace) {
//       return Description.withError("Data not found / Connection issue");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: wite,
//       appBar: AppBar(
//         backgroundColor: wite,
//         title: Image.asset("assets/images/1.png"),
//       ),
//       body:Container(
//         child: item(),
//       ),
//     );
//   }
//   Widget item() {
//     return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10.2),
//         height: 200.0,
//         child: FutureBuilder(
//             future: fetchDescription(),
//
//             builder: (context,snapshot){
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.transparent,
//                   ),
//                 );
//               }else
//
//                 return ListView.builder(
//                   itemCount: snapshot.data.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//
//                         margin: EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//
//                             Card(
//                               child: Container(
//                                 margin: EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: <Widget>[
//                                     HtmlWidget('${}')
//                                     */
// /*Text(
//                           "${model.wALFTVAPI[index].appDescription}",
//                           style: TextStyle(fontSize: 18),
//                         ),*//*
//
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                           ],
//                         )
//                     );
//                   },
//                 );
//             }
//         )
//     );
//   }
// }
// */
