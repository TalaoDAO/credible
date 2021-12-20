// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyCard _$LoyaltyCardFromJson(Map<String, dynamic> json) {
  return LoyaltyCard(
    json['id'] as String,
    json['type'] as String,
    json['address'] as String? ?? '',
    json['familyName'] as String? ?? '',
    CredentialSubject.fromJsonAuthor(json['issuedBy']),
    json['birthDate'] as String? ?? '',
    json['givenName'] as String? ?? '',
    json['programName'] as String? ?? '',
    json['telephone'] as String? ?? '',
  );
}

Map<String, dynamic> _$LoyaltyCardToJson(LoyaltyCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'address': instance.address,
      'familyName': instance.familyName,
      'issuedBy': instance.issuedBy.toJson(),
      'birthDate': instance.birthDate,
      'givenName': instance.givenName,
      'programName': instance.programName,
      'telephone': instance.telephone,
    };
