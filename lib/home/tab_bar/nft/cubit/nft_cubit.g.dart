// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftState _$NftStateFromJson(Map<String, dynamic> json) => NftState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NftModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$NftStateToJson(NftState instance) => <String, dynamic>{
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
