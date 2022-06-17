// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'associated_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssociatedWalletModel _$AssociatedWalletModelFromJson(
        Map<String, dynamic> json) =>
    AssociatedWalletModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$AssociatedWalletModelToJson(
        AssociatedWalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
    };
