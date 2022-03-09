

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/api_repository.dart';
import '../../api_bloc.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiRepository _apiRepository = ApiRepository();

  @override
  ApiState get initialState => ApiInitial();

  @override
  Stream<ApiState> mapEventToState(ApiEvent event,) async* {
    if (event is GetApiList) {
      try {
        yield ApiLoading();
        final mList = await _apiRepository.fetchApiList();
        yield ApiLoaded(mList);
        if (mList.error != null) {
          yield ApiError(mList.error);
        }
      } on NetworkError {
        yield ApiError("Failed to fetch data. is your device online?");
      }
    }
  }
}