
import 'package:dio/dio.dart';

import '../network/model/app_privacy.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'https://acanvod.acan.group/myapiv2/appinfo/malikia/privacy/json';

  Future<Appprivacy> fetchApiList() async {
    try {
      Response response = await _dio.get(_url);
      return Appprivacy.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Appprivacy.withError("Data not found / Connection issue");
    }
  }
}