import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/check_issuer/models/organization_info.dart';

part 'issuer.g.dart';

@JsonSerializable()
class Issuer {
  @JsonKey(defaultValue: '')
  final String preferredName;
  @JsonKey(defaultValue: [])
  final List<String> did;
  final OrganizationInfo organizationInfo;

  factory Issuer.fromJson(Map<String, dynamic> json) =>
      _$IssuerFromJson(json['issuer']);

  Issuer(this.preferredName, this.did, this.organizationInfo);

  Map<String, dynamic> toJson() => _$IssuerToJson(this);
}
