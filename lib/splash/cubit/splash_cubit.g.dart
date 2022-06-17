// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashState _$SplashStateFromJson(Map<String, dynamic> json) => SplashState(
      status: $enumDecodeNullable(_$SplashStatusEnumMap, json['status']) ??
          SplashStatus.init,
      versionNumber: json['versionNumber'] as String? ?? '',
    );

Map<String, dynamic> _$SplashStateToJson(SplashState instance) =>
    <String, dynamic>{
      'status': _$SplashStatusEnumMap[instance.status],
      'versionNumber': instance.versionNumber,
    };

const _$SplashStatusEnumMap = {
  SplashStatus.init: 'init',
  SplashStatus.routeToPassCode: 'routeToPassCode',
  SplashStatus.routeToHomePage: 'routeToHomePage',
};
