// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      email: json['email'] as String,
      issuerVerificationSetting: json['issuerVerificationSetting'] as bool,
      companyName: json['companyName'] as String? ?? '',
      companyWebsite: json['companyWebsite'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'location': instance.location,
      'email': instance.email,
      'companyName': instance.companyName,
      'companyWebsite': instance.companyWebsite,
      'jobTitle': instance.jobTitle,
      'issuerVerificationSetting': instance.issuerVerificationSetting,
    };
