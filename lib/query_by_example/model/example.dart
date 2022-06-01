import 'package:json_annotation/json_annotation.dart';
import 'package:talao/query_by_example/model/example_issuer.dart';

part 'example.g.dart';

@JsonSerializable(explicitToJson: true)
class Example {
  final String? type;
  final List<ExampleIssuer>? trustedIssuer;

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);

  Example({required this.type, required this.trustedIssuer});

  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}
