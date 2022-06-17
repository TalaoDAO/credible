// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhonePassModel _$PhonePassModelFromJson(Map<String, dynamic> json) =>
    PhonePassModel(
      expires: json['expires'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$PhonePassModelToJson(PhonePassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'expires': instance.expires,
      'phone': instance.phone,
    };
