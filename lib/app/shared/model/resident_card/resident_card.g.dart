// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentCard _$ResidentCardFromJson(Map<String, dynamic> json) {
  return ResidentCard(
    json['id'] as String,
    json['gender'] as String? ?? '',
    json['maritalStatus'] as String? ?? '',
    json['type'] as String,
    json['birthPlace'] as String? ?? '',
    json['nationality'] as String? ?? '',
    json['address'] as String? ?? '',
    json['identifier'] as String? ?? '',
    json['familyName'] as String? ?? '',
    json['image'] as String? ?? '',
    Author.fromJson(json['issuedBy'] as Map<String, dynamic>),
    json['birthDate'] as String? ?? '',
    json['givenName'] as String? ?? '',
  );
}

Map<String, dynamic> _$ResidentCardToJson(ResidentCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gender': instance.gender,
      'maritalStatus': instance.maritalStatus,
      'type': instance.type,
      'birthPlace': instance.birthPlace,
      'nationality': instance.nationality,
      'address': instance.address,
      'identifier': instance.identifier,
      'familyName': instance.familyName,
      'image': instance.image,
      'issuedBy': instance.issuedBy,
      'birthDate': instance.birthDate,
      'givenName': instance.givenName,
    };
