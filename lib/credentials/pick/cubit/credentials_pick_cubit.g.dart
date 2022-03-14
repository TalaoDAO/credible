// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsPickState _$CredentialsPickStateFromJson(
        Map<String, dynamic> json) =>
    CredentialsPickState(
      selection:
          (json['selection'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$CredentialsPickStateToJson(
        CredentialsPickState instance) =>
    <String, dynamic>{
      'selection': instance.selection,
    };
