



import '../network/model/app_description.dart';
import 'api_provider_alaune.dart';

class AlauneRepository {
  final _provider = AlauneProvider();

  Future<Appdescription> fetchApiList() {
    return _provider.fetchApiList();
  }
}

class NetworkError extends Error {}