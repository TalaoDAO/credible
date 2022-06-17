// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateMessage _$StateMessageFromJson(Map<String, dynamic> json) => StateMessage(
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.error,
    );

Map<String, dynamic> _$StateMessageToJson(StateMessage instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type],
    };

const _$MessageTypeEnumMap = {
  MessageType.error: 'error',
  MessageType.warning: 'warning',
  MessageType.info: 'info',
  MessageType.success: 'success',
};
