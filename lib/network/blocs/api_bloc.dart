

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/app_privacy.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();
}

class GetApiList extends ApiEvent {
  @override
  List<Object> get props => null;
}
abstract class ApiState extends Equatable {
  const ApiState();
}

class ApiInitial extends ApiState {
  const ApiInitial();
  @override
  List<Object> get props => [];
}

class ApiLoading extends ApiState {
  const ApiLoading();
  @override
  List<Object> get props => null;
}

class ApiLoaded extends ApiState {
  final Appprivacy appprivacy;
  const ApiLoaded(this.appprivacy);
  @override
  List<Object> get props => [appprivacy];
}

class ApiError extends ApiState {
  final icon =Icon(Icons.network_check_sharp);
  final String message = "error de connexion";
   ApiError(icon);
  @override
  List<Object> get props => [icon,message];
}