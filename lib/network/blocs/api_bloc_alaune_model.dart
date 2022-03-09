
import 'package:equatable/equatable.dart';

import '../model/app_description.dart';

abstract class AlauneEvent extends Equatable {
  const AlauneEvent();
}

class GetAlauneList extends AlauneEvent {
  @override
  List<Object> get props => null;
}
abstract class AlauneState extends Equatable {
  const AlauneState();
}

class AlauneInitial extends AlauneState {
  const AlauneInitial();
  @override
  List<Object> get props => [];
}

class AlauneLoading extends AlauneState {
  const AlauneLoading();
  @override
  List<Object> get props => null;
}

class AlauneLoaded extends AlauneState {
  final Appdescription appdescription;
  const AlauneLoaded(this.appdescription);
  @override
  List<Object> get props => [appdescription];
}

class AlauneError extends AlauneState {
  final String message;
  const AlauneError(this.message);
  @override
  List<Object> get props => [message];
}