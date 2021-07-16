import 'package:json_annotation/json_annotation.dart';

part 'proof.g.dart';

@JsonSerializable()
class Proof {
  final String type;
  final String proofPurpose;
  final String verificationMethod;
  final String created;
  final String jws;

  Proof(this.type, this.proofPurpose, this.verificationMethod, this.created,
      this.jws);

  factory Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

  Map<String, dynamic> toJson() => _$ProofToJson(this);
}
