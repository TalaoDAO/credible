// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      json['contract'] as String? ?? '',
      json['name'] as String? ?? '',
      json['symbol'] as String? ?? '',
      json['logoPath'] as String? ?? '',
      json['balance'] as int,
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'contract': instance.contract,
      'symbol': instance.symbol,
      'name': instance.name,
      'logoPath': instance.logoPath,
      'balance': instance.balance,
    };
