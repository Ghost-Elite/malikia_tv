import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../configs/size_config.dart';
import '../network/blocs/api/bloc/api_bloc.dart';
import '../network/blocs/api_bloc.dart';
import '../network/model/app_privacy.dart';
import 'drawers.dart';
import 'home_page.dart';

class PolitiquePage extends StatefulWidget {
  @override
  _PolitiquePageState createState() => _PolitiquePageState();
}

class _PolitiquePageState extends State<PolitiquePage> {
  final ApiBloc _newsBloc = ApiBloc();


  @override
  void initState() {
    _newsBloc.add(GetApiList());
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
        width: SizeConfi.screenWidth,
        height: SizeConfi.screenHeight,
        color: bg,
        child: SingleChildScrollView(
          child: _buildListApi(),
        ),
      ),
    );
  }
  Widget _buildListApi() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<ApiBloc, ApiState>(
          listener: (context, state) {
            if (state is ApiError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: (state.icon),
                ),
              );
            }
          },
          child: BlocBuilder<ApiBloc, ApiState>(
            builder: (context, state) {
              if (state is ApiInitial) {
                return _buildLoading();
              } else if (state is ApiLoading) {
                return _buildLoading();
              } else if (state is ApiLoaded) {
                return _buildCard(context, state.appprivacy);
              } else if (state is ApiError) {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Appprivacy model) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            HtmlWidget('<br>${model.appPrivacy}</br>')

          ],
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
