// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftModel _$NftModelFromJson(Map<String, dynamic> json) => NftModel(
      json['id'] as String? ?? '',
      json['name'] as String? ?? '',
      json['displayUri'] as String? ?? '',
      json['balance'] as String,
    );

Map<String, dynamic> _$NftModelToJson(NftModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayUri': instance.displayUri,
      'balance': instance.balance,
    };
