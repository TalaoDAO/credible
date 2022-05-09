import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/proof.dart';

part 'proof_ebsi.g.dart';

@JsonSerializable(explicitToJson: true)
class ProofEbsi extends Proof {
  @override
  final String type;
  @override
  final String created;
  @override
  final String jws;
  final String creator;
  final String domain;
  final String nonce;

  ProofEbsi(
      this.type, this.created, this.jws, this.creator, this.domain, this.nonce)
      : super('', '', '');

  factory ProofEbsi.fromJson(Map<String, dynamic> json) =>
      _$ProofEbsiFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProofEbsiToJson(this);

  factory ProofEbsi.dummy() => ProofEbsi(
        'dummy',
        'dummy',
        'dummy',
        'dummy',
        'dummy',
        'dummy',
      );
}
