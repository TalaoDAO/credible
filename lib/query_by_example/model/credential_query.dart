import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/translation.dart';

part 'credential_query.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialQuery {
  @JsonKey(defaultValue: [])
  final List<Translation> reason;
//TODO: Add example and issuer fields when creating automatic credential selection
  factory CredentialQuery.fromJson(Map<String, dynamic> json) => _$CredentialQueryFromJson(json);

  CredentialQuery(this.reason);


  Map<String, dynamic> toJson() => _$CredentialQueryToJson(this);

}
