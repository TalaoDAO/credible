// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_scan_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRCodeScanState _$QRCodeScanStateFromJson(Map<String, dynamic> json) =>
    QRCodeScanState(
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QRCodeScanStateToJson(QRCodeScanState instance) =>
    <String, dynamic>{
      'uri': instance.uri?.toString(),
      'message': instance.message,
    };
