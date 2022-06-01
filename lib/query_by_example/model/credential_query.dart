import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/query_by_example/model/example.dart';

part 'credential_query.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialQuery {
  @JsonKey(defaultValue: [])
  final List<Translation>? reason;
  final Example? example;
  factory CredentialQuery.fromJson(Map<String, dynamic> json) =>
      _$CredentialQueryFromJson(json);

  CredentialQuery(this.reason, this.example);

  Map<String, dynamic> toJson() => _$CredentialQueryToJson(this);
}
