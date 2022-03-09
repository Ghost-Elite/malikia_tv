import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class FacebookPage extends StatefulWidget {
  const FacebookPage({Key key}) : super(key: key);

  @override
  _FacebookPageState createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  static const _url = 'https://www.facebook.com//';
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
