// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateMessage _$StateMessageFromJson(Map<String, dynamic> json) => StateMessage(
      serverMessage: json['message'] as String?,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$StateMessageToJson(StateMessage instance) =>
    <String, dynamic>{
      'message': instance.serverMessage,
      'type': _$MessageTypeEnumMap[instance.type],
    };

const _$MessageTypeEnumMap = {
  MessageType.error: 'error',
  MessageType.warning: 'warning',
  MessageType.info: 'info',
  MessageType.success: 'success',
};
