


import '../network/model/app_privacy.dart';
import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<Appprivacy> fetchApiList() {
    return _provider.fetchApiList();
  }
}

class NetworkError extends Error {}