// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      json['id'] as String,
      json['type'] as String,
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
      json['identifier'] as String? ?? '',
      Offer.fromJson(json['offer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'identifier': instance.identifier,
      'offer': instance.offer.toJson(),
      'issuedBy': instance.issuedBy.toJson(),
    };
