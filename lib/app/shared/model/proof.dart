import 'package:json_annotation/json_annotation.dart';

part 'proof.g.dart';

@JsonSerializable(explicitToJson: true)
class Proof {
  final String created;
  final String jws;
  final String type;

  Proof(this.type, this.created, this.jws);

  factory Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

  Map<String, dynamic> toJson() => _$ProofToJson(this);

  factory Proof.dummy() => Proof(
        'dummy',
        'dummy',
        'dummy',
      );
}
