// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyCardModel _$LoyaltyCardModelFromJson(Map<String, dynamic> json) =>
    LoyaltyCardModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      address: json['address'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      birthDate: json['birthDate'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      programName: json['programName'] as String? ?? '',
      telephone: json['telephone'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$LoyaltyCardModelToJson(LoyaltyCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'address': instance.address,
      'familyName': instance.familyName,
      'birthDate': instance.birthDate,
      'givenName': instance.givenName,
      'programName': instance.programName,
      'telephone': instance.telephone,
      'email': instance.email,
    };
