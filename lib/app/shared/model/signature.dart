import 'package:json_annotation/json_annotation.dart';

part 'signature.g.dart';

@JsonSerializable(explicitToJson: true)
class Signature {
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String jobTitle;
  @JsonKey(defaultValue: '')
  final String name;

  factory Signature.fromJson(Map<String, dynamic> json) =>
      _$SignatureFromJson(json);

  Signature(this.image, this.jobTitle, this.name);

  factory Signature.emptySignature() => Signature('', '', '');

  Map<String, dynamic> toJson() => _$SignatureToJson(this);
}
