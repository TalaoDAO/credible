// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialSubjectModel _$CredentialSubjectModelFromJson(
        Map<String, dynamic> json) =>
    CredentialSubjectModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      credentialSubjectType: $enumDecode(
          _$CredentialSubjectTypeEnumMap, json['credentialSubjectType']),
      credentialCategory:
          $enumDecode(_$CredentialCategoryEnumMap, json['credentialCategory']),
    );

Map<String, dynamic> _$CredentialSubjectModelToJson(
        CredentialSubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'credentialSubjectType':
          _$CredentialSubjectTypeEnumMap[instance.credentialSubjectType],
      'credentialCategory':
          _$CredentialCategoryEnumMap[instance.credentialCategory],
    };

const _$CredentialSubjectTypeEnumMap = {
  CredentialSubjectType.associatedWallet: 'associatedWallet',
  CredentialSubjectType.certificateOfEmployment: 'certificateOfEmployment',
  CredentialSubjectType.defaultCredential: 'defaultCredential',
  CredentialSubjectType.ecole42LearningAchievement:
      'ecole42LearningAchievement',
  CredentialSubjectType.emailPass: 'emailPass',
  CredentialSubjectType.identityPass: 'identityPass',
  CredentialSubjectType.learningAchievement: 'learningAchievement',
  CredentialSubjectType.loyaltyCard: 'loyaltyCard',
  CredentialSubjectType.over18: 'over18',
  CredentialSubjectType.phonePass: 'phonePass',
  CredentialSubjectType.professionalExperienceAssessment:
      'professionalExperienceAssessment',
  CredentialSubjectType.professionalSkillAssessment:
      'professionalSkillAssessment',
  CredentialSubjectType.professionalStudentCard: 'professionalStudentCard',
  CredentialSubjectType.residentCard: 'residentCard',
  CredentialSubjectType.selfIssued: 'selfIssued',
  CredentialSubjectType.studentCard: 'studentCard',
  CredentialSubjectType.talao: 'talao',
  CredentialSubjectType.voucher: 'voucher',
};

const _$CredentialCategoryEnumMap = {
  CredentialCategory.gamingCards: 'gamingCards',
  CredentialCategory.identityCards: 'identityCards',
  CredentialCategory.communityCards: 'communityCards',
  CredentialCategory.othersCards: 'othersCards',
};
