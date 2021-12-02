import 'package:json_annotation/json_annotation.dart';
part 'evidence.g.dart';

@JsonSerializable()
class Evidence {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: [])
  final List<String> type;

  factory Evidence.fromJson(Map<String, dynamic> json) =>
      _$EvidenceFromJson(json);
  factory Evidence.emptyEvidence() => Evidence('', []);

  Evidence(this.id, this.type);

  Map<String, dynamic> toJson() => _$EvidenceToJson(this);
}
