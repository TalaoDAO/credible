// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeCredential _$HomeCredentialFromJson(Map<String, dynamic> json) =>
    HomeCredential(
      credentialModel: json['credentialModel'] == null
          ? null
          : CredentialModel.fromJson(
              json['credentialModel'] as Map<String, dynamic>),
      link: json['link'] as String?,
      image: json['image'] as String?,
      isDummy: json['isDummy'] as bool,
      credentialSubjectType: $enumDecode(
          _$CredentialSubjectTypeEnumMap, json['credentialSubjectType']),
    );

Map<String, dynamic> _$HomeCredentialToJson(HomeCredential instance) =>
    <String, dynamic>{
      'credentialModel': instance.credentialModel?.toJson(),
      'link': instance.link,
      'image': instance.image,
      'isDummy': instance.isDummy,
      'credentialSubjectType':
          _$CredentialSubjectTypeEnumMap[instance.credentialSubjectType],
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
