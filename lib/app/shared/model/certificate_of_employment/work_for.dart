import 'package:json_annotation/json_annotation.dart';

part 'work_for.g.dart';

@JsonSerializable()
class WorkFor {
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String logo;
  @JsonKey(defaultValue: '')
  final String name;

  factory WorkFor.fromJson(Map<String, dynamic> json) =>
      _$WorkForFromJson(json);

  WorkFor(this.address, this.logo, this.name);

  Map<String, dynamic> toJson() => _$WorkForToJson(this);
}
