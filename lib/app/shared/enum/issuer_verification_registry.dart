import 'package:json_annotation/json_annotation.dart';

enum IssuerVerificationRegistry {
  @JsonValue('none')
  none,
  @JsonValue('talao')
  talao,
  @JsonValue('ebsi')
  ebsi,
}
