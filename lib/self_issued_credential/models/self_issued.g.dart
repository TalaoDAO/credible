// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssued _$SelfIssuedFromJson(Map<String, dynamic> json) => SelfIssued(
      id: json['id'] as String,
      address: json['address'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      type: json['type'] as String? ?? 'SelfIssued',
      telephone: json['telephone'] as String? ?? '',
      email: json['email'] as String? ?? '',
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
