// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletState _$WalletStateFromJson(Map<String, dynamic> json) => WalletState(
      status: $enumDecodeNullable(_$WalletStatusEnumMap, json['status']) ??
          WalletStatus.init,
      credentials: (json['credentials'] as List<dynamic>?)
          ?.map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletStateToJson(WalletState instance) =>
    <String, dynamic>{
      'status': _$WalletStatusEnumMap[instance.status],
      'credentials': instance.credentials,
    };

const _$WalletStatusEnumMap = {
  WalletStatus.init: 'init',
  WalletStatus.idle: 'idle',
  WalletStatus.insert: 'insert',
  WalletStatus.delete: 'delete',
  WalletStatus.update: 'update',
  WalletStatus.reset: 'reset',
  WalletStatus.search: 'search',
};
