
import 'package:dio/dio.dart';

import '../network/model/app_description.dart';

class AlauneProvider {
  final Dio _dio = Dio();
  final String _url = 'https://acanvod.acan.group/myapiv2/appinfo/malikia/description/json';

  Future<Appdescription> fetchApiList() async {
    try {
      Response response = await _dio.get(_url);
      return Appdescription.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Appdescription.withError("Data not found / Connection issue");
    }
  }
}