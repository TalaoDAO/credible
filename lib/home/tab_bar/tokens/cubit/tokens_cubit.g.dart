// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensState _$TokensStateFromJson(Map<String, dynamic> json) => TokensState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TokenModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TokensStateToJson(TokensState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'message': instance.message,
      'data': instance.data,
    };

const _$AppStatusEnumMap = {
  AppStatus.init: 'init',
  AppStatus.fetching: 'fetching',
  AppStatus.loading: 'loading',
  AppStatus.populate: 'populate',
  AppStatus.error: 'error',
  AppStatus.errorWhileFetching: 'errorWhileFetching',
  AppStatus.success: 'success',
};
