// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailPassModel _$EmailPassModelFromJson(Map<String, dynamic> json) =>
    EmailPassModel(
      expires: json['expires'] as String? ?? '',
      email: json['email'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      passbaseMetadata: json['passbaseMetadata'] as String? ?? '',
    );

Map<String, dynamic> _$EmailPassModelToJson(EmailPassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'expires': instance.expires,
      'email': instance.email,
      'passbaseMetadata': instance.passbaseMetadata,
    };
