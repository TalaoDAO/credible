// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_credential_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultCredentialSubjectModel _$DefaultCredentialSubjectModelFromJson(
        Map<String, dynamic> json) =>
    DefaultCredentialSubjectModel(
      json['id'] as String?,
      json['type'] as String?,
      CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$DefaultCredentialSubjectModelToJson(
        DefaultCredentialSubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
    };
