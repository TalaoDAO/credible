import 'package:json_annotation/json_annotation.dart';

part 'organization_info.g.dart';

@JsonSerializable()
class OrganizationInfo {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String legalName;
  @JsonKey(defaultValue: '')
  final String currentAddress;
  @JsonKey(defaultValue: '')
  final String website;
  @JsonKey(defaultValue: [])
  final List<String> issuerDomain;

  factory OrganizationInfo.fromJson(Map<String, dynamic> json) =>
      _$OrganizationInfoFromJson(json);

  OrganizationInfo(
      {required this.id,
      required this.legalName,
      required this.currentAddress,
      required this.website,
      required this.issuerDomain});

  factory OrganizationInfo.emptyOrganizationInfo() => OrganizationInfo(
      id: '', legalName: '', website: '', issuerDomain: [], currentAddress: '');

  Map<String, dynamic> toJson() => _$OrganizationInfoToJson(this);
}
