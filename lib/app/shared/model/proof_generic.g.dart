// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_generic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProofGeneric _$ProofGenericFromJson(Map<String, dynamic> json) => ProofGeneric(
      json['type'] as String,
      json['proofPurpose'] as String,
      json['verificationMethod'] as String,
      json['created'] as String,
      json['jws'] as String,
    );

Map<String, dynamic> _$ProofGenericToJson(ProofGeneric instance) =>
    <String, dynamic>{
      'type': instance.type,
      'proofPurpose': instance.proofPurpose,
      'verificationMethod': instance.verificationMethod,
      'created': instance.created,
      'jws': instance.jws,
    };
