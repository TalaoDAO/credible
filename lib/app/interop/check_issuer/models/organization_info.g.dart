// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationInfo _$OrganizationInfoFromJson(Map<String, dynamic> json) {
  return OrganizationInfo(
    json['id'] as String? ?? '',
    json['legalName'] as String? ?? '',
    json['currentAddress'] as String? ?? '',
    json['website'] as String? ?? '',
    (json['issuerDomain'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$OrganizationInfoToJson(OrganizationInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'legalName': instance.legalName,
      'currentAddress': instance.currentAddress,
      'website': instance.website,
      'issuerDomain': instance.issuerDomain,
    };
