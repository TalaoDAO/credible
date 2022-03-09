import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/message.dart';

part 'qr_code_state.g.dart';

@JsonSerializable()
class QRCodeState extends Equatable {
  QRCodeState({this.uri, this.route, this.message});

  factory QRCodeState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeStateFromJson(json);

  final Uri? uri;
  @JsonKey(ignore: true)
  final Route? route;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeStateToJson(this);

  @override
  List<Object?> get props => [uri, route, message];
}

class QRCodeStateWorking extends QRCodeState {}

class QRCodeStateHost extends QRCodeState {
  QRCodeStateHost({Uri? uri}) : super(uri: uri);
}

class QRCodeStateSuccess extends QRCodeState {
  QRCodeStateSuccess({Route? route}) : super(route: route);
}

class QRCodeStateUnknown extends QRCodeState {}

class QRCodeStateMessage extends QRCodeState {
  QRCodeStateMessage({StateMessage? message}) : super(message: message);
}
