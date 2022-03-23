// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileState _$ProfileStateFromJson(Map<String, dynamic> json) => ProfileState(
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      model: ProfileModel.fromJson(json['model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileStateToJson(ProfileState instance) =>
    <String, dynamic>{
      'model': instance.model.toJson(),
      'message': instance.message?.toJson(),
    };
