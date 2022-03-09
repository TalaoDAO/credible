// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRCodeState _$QRCodeStateFromJson(Map<String, dynamic> json) => QRCodeState(
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QRCodeStateToJson(QRCodeState instance) =>
    <String, dynamic>{
      'uri': instance.uri?.toString(),
      'message': instance.message,
    };
