import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/proof.dart';

part 'proof_generic.g.dart';

@JsonSerializable(explicitToJson: true)
class ProofGeneric extends Proof {
  @override
  final String type;
  final String proofPurpose;
  final String verificationMethod;
  @override
  final String created;
  @override
  final String jws;
  ProofGeneric(this.type, this.proofPurpose, this.verificationMethod,
      this.created, this.jws)
      : super('', '', '');

  factory ProofGeneric.fromJson(Map<String, dynamic> json) =>
      _$ProofGenericFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProofGenericToJson(this);

  factory ProofGeneric.dummy() => ProofGeneric(
        'dummy',
        'dummy',
        'dummy',
        'dummy',
        'dummy',
      );
}
