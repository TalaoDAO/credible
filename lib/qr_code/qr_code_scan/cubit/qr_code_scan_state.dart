import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/message.dart';

part 'qr_code_scan_state.g.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  QRCodeScanState({this.uri, this.route, this.message});

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final Uri? uri;
  @JsonKey(ignore: true)
  final Route? route;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  @override
  List<Object?> get props => [uri, route, message];
}

class QRCodeScanStateWorking extends QRCodeScanState {}

class QRCodeScanStateHost extends QRCodeScanState {
  QRCodeScanStateHost({Uri? uri}) : super(uri: uri);
}

class QRCodeScanStateSuccess extends QRCodeScanState {
  QRCodeScanStateSuccess({Route? route}) : super(route: route);
}

class QRCodeScanStateUnknown extends QRCodeScanState {}

class QRCodeScanStateMessage extends QRCodeScanState {
  QRCodeScanStateMessage({StateMessage? message}) : super(message: message);
}
