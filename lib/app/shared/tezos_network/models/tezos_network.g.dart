// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezos_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezosNetwork _$TezosNetworkFromJson(Map<String, dynamic> json) => TezosNetwork(
      json['networkname'] as String,
      json['tzktUrl'] as String,
      json['apiKey'] as String,
    );

Map<String, dynamic> _$TezosNetworkToJson(TezosNetwork instance) =>
    <String, dynamic>{
      'networkname': instance.networkname,
      'tzktUrl': instance.tzktUrl,
      'apiKey': instance.apiKey,
    };
