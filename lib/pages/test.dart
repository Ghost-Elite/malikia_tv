import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class testpage extends StatefulWidget {
  const testpage({Key key}) : super(key: key);

  @override
  _testpageState createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sample App'),
      ),
      body: Center(child: Text("")),

    );
  }
}
