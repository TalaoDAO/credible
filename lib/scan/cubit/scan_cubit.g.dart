// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanState _$ScanStateFromJson(Map<String, dynamic> json) => ScanState(
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      preview: json['preview'] as Map<String, dynamic>?,
      data: json['data'] as Map<String, dynamic>?,
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      keyId: json['keyId'] as String?,
      challenge: json['challenge'] as String?,
      domain: json['domain'] as String?,
      credentials: (json['credentials'] as List<dynamic>?)
          ?.map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sIOPV2Param: json['sIOPV2Param'] == null
          ? null
          : SIOPV2Param.fromJson(json['sIOPV2Param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScanStateToJson(ScanState instance) => <String, dynamic>{
      'message': instance.message,
      'preview': instance.preview,
      'data': instance.data,
      'uri': instance.uri?.toString(),
      'keyId': instance.keyId,
      'challenge': instance.challenge,
      'domain': instance.domain,
      'credentials': instance.credentials,
      'sIOPV2Param': instance.sIOPV2Param,
    };
