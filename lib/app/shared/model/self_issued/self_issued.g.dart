// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssued _$SelfIssuedFromJson(Map<String, dynamic> json) => SelfIssued(
      json['id'] as String,
      json['type'] as String,
      json['address'] as String? ?? '',
      json['familyName'] as String? ?? '',
      json['givenName'] as String? ?? '',
      json['telephone'] as String? ?? '',
      json['email'] as String? ?? '',
    );

Map<String, dynamic> _$SelfIssuedToJson(SelfIssued instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'address': instance.address,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'telephone': instance.telephone,
      'email': instance.email,
    };
