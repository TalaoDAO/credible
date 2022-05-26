// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_manifest_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialManifestPickState _$CredentialManifestPickStateFromJson(
        Map<String, dynamic> json) =>
    CredentialManifestPickState(
      selection:
          (json['selection'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$CredentialManifestPickStateToJson(
        CredentialManifestPickState instance) =>
    <String, dynamic>{
      'selection': instance.selection,
    };
