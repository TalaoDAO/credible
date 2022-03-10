import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/message.dart';

part 'qr_code_scan_state.g.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  QRCodeScanState({this.uri, this.route, this.promptActive, this.message});

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final Uri? uri;
  @JsonKey(ignore: true)
  final Route? route;
  final bool? promptActive;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  QRCodeScanState copyWith(
      {Uri? uri, Route? route, bool? promptActive, StateMessage? message}) {
    return QRCodeScanState(
      uri: uri ?? this.uri,
      route: route ?? this.route,
      promptActive: promptActive ?? this.promptActive,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [uri, route, promptActive, message];
}

class QRCodeScanStateWorking extends QRCodeScanState {
  QRCodeScanStateWorking() : super(promptActive: false);
}

class QRCodeScanStateHost extends QRCodeScanState {
  QRCodeScanStateHost({Uri? uri}) : super(uri: uri, promptActive: false);
}

class QRCodeScanStateSuccess extends QRCodeScanState {
  QRCodeScanStateSuccess({Route? route})
      : super(route: route, promptActive: false);
}

class QRCodeScanStateUnknown extends QRCodeScanState {
  QRCodeScanStateUnknown() : super(promptActive: false);
}

class QRCodeScanStateMessage extends QRCodeScanState {
  QRCodeScanStateMessage({StateMessage? message})
      : super(message: message, promptActive: false);
}
