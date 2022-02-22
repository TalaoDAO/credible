// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletState _$WalletStateFromJson(Map<String, dynamic> json) => WalletState(
      status: $enumDecodeNullable(_$KeyStatusEnumMap, json['status']) ??
          KeyStatus.needsKey,
      credentials: (json['credentials'] as List<dynamic>?)
          ?.map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletStateToJson(WalletState instance) =>
    <String, dynamic>{
      'status': _$KeyStatusEnumMap[instance.status],
      'credentials': instance.credentials,
    };

const _$KeyStatusEnumMap = {
  KeyStatus.needsKey: 'needsKey',
  KeyStatus.hasKey: 'hasKey',
};
