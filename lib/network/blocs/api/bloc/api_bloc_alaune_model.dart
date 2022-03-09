

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/api_repository_alaune.dart';
import '../../api_bloc_alaune_model.dart';


class AlauneBloc extends Bloc<AlauneEvent, AlauneState> {
  final AlauneRepository _alauneRepository = AlauneRepository();
  @override
  AlauneState get initialState => AlauneInitial();

  @override
  Stream<AlauneState> mapEventToState(
    AlauneEvent event,
  ) async* {
    if (event is GetAlauneList) {
      try {
        yield AlauneLoading();
        final mList = await _alauneRepository.fetchApiList();
        yield AlauneLoaded(mList);
        if (mList.error != null) {
          yield AlauneError(mList.error);
        }
      } on NetworkError {
        yield AlauneError("Failed to fetch data. is your device online?");
      }
    }
  }
}
