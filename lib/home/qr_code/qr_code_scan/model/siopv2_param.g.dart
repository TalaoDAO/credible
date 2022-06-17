// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'siopv2_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIOPV2Param _$SIOPV2ParamFromJson(Map<String, dynamic> json) => SIOPV2Param(
      nonce: json['nonce'] as String?,
      redirect_uri: json['redirect_uri'] as String?,
      request_uri: json['request_uri'] as String?,
      claims: json['claims'] as String?,
      requestUriPayload: json['requestUriPayload'] as String?,
    );

Map<String, dynamic> _$SIOPV2ParamToJson(SIOPV2Param instance) =>
    <String, dynamic>{
      'nonce': instance.nonce,
      'redirect_uri': instance.redirect_uri,
      'request_uri': instance.request_uri,
      'claims': instance.claims,
      'requestUriPayload': instance.requestUriPayload,
    };
