// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_ebsi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProofEbsi _$ProofEbsiFromJson(Map<String, dynamic> json) => ProofEbsi(
      json['type'] as String,
      json['created'] as String,
      json['jws'] as String,
      json['creator'] as String,
      json['domain'] as String,
      json['nonce'] as String,
    );

Map<String, dynamic> _$ProofEbsiToJson(ProofEbsi instance) => <String, dynamic>{
      'type': instance.type,
      'created': instance.created,
      'jws': instance.jws,
      'creator': instance.creator,
      'domain': instance.domain,
      'nonce': instance.nonce,
    };
