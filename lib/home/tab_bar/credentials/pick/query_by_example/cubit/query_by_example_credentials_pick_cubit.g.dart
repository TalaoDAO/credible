// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_by_example_credentials_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryByExampleCredentialPickState _$QueryByExampleCredentialPickStateFromJson(
        Map<String, dynamic> json) =>
    QueryByExampleCredentialPickState(
      selection:
          (json['selection'] as List<dynamic>?)?.map((e) => e as int).toList(),
      filteredCredentialList: (json['filteredCredentialList'] as List<dynamic>)
          .map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryByExampleCredentialPickStateToJson(
        QueryByExampleCredentialPickState instance) =>
    <String, dynamic>{
      'selection': instance.selection,
      'filteredCredentialList': instance.filteredCredentialList,
    };
