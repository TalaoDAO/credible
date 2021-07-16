import 'package:json_annotation/json_annotation.dart';

part 'signature_lines.g.dart';

@JsonSerializable()
class SignatureLines {
  final String image;

  SignatureLines(this.image);

  factory SignatureLines.fromJson(Map<String, dynamic> json) =>
      _$SignatureLinesFromJson(json);

  Map<String, dynamic> toJson() => _$SignatureLinesToJson(this);
}
