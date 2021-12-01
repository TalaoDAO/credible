import 'package:json_annotation/json_annotation.dart';
import 'package:talao/query_by_example/model/credential_query.dart';

part 'query.g.dart';

@JsonSerializable(explicitToJson: true)
class Query {
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: [])
  final List<CredentialQuery> credentialQuery;

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  Query({required this.type, required this.credentialQuery});

  Map<String, dynamic> toJson() => _$QueryToJson(this);

}
