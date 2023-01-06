// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletState _$WalletStateFromJson(Map<String, dynamic> json) => WalletState(
      status: $enumDecodeNullable(_$WalletStatusEnumMap, json['status']) ??
          WalletStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      currentCryptoIndex: json['currentCryptoIndex'] as int? ?? 0,
      cryptoAccount: json['cryptoAccount'] == null
          ? null
          : CryptoAccount.fromJson(
              json['cryptoAccount'] as Map<String, dynamic>),
      credentials: (json['credentials'] as List<dynamic>?)
          ?.map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletStateToJson(WalletState instance) =>
    <String, dynamic>{
      'status': _$WalletStatusEnumMap[instance.status]!,
      'credentials': instance.credentials,
      'message': instance.message,
      'currentCryptoIndex': instance.currentCryptoIndex,
      'cryptoAccount': instance.cryptoAccount,
    };

const _$WalletStatusEnumMap = {
  WalletStatus.init: 'init',
  WalletStatus.populate: 'populate',
  WalletStatus.loading: 'loading',
  WalletStatus.insert: 'insert',
  WalletStatus.delete: 'delete',
  WalletStatus.update: 'update',
  WalletStatus.reset: 'reset',
  WalletStatus.error: 'error',
};
