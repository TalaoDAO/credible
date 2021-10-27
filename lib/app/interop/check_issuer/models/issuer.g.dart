// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issuer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issuer _$IssuerFromJson(Map<String, dynamic> json) {
  return Issuer(
    json['preferredName'] as String? ?? '',
    (json['did'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    OrganizationInfo.fromJson(json['organizationInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IssuerToJson(Issuer instance) => <String, dynamic>{
      'preferredName': instance.preferredName,
      'did': instance.did,
      'organizationInfo': instance.organizationInfo,
    };
