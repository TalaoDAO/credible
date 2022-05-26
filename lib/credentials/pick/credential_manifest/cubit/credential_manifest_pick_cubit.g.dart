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
      filteredCredentialList: (json['filteredCredentialList'] as List<dynamic>)
          .map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CredentialManifestPickStateToJson(
        CredentialManifestPickState instance) =>
    <String, dynamic>{
      'selection': instance.selection,
      'filteredCredentialList': instance.filteredCredentialList,
    };
