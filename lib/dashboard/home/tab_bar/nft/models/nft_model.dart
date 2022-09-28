import 'package:altme/app/shared/constants/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_model.g.dart';

@JsonSerializable()
@immutable
class NftModel extends Equatable {
  const NftModel(
    this.id,
    this.name,
    this.displayUri,
    this.balance,
    this.description,
  );

  factory NftModel.fromJson(Map<String, dynamic> json) =>
      _$NftModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String displayUri;
  final String balance;
  final String? description;

  Map<String, dynamic> toJson() => _$NftModelToJson(this);

  String get displayUrl => displayUri.replaceAll(
        'ipfs://',
        Urls.talaoIpfsGateway,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        displayUri,
        balance,
        description,
      ];
}
