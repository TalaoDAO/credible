import 'package:json_annotation/json_annotation.dart';
part 'display.g.dart';

@JsonSerializable()
class Display {
  @JsonKey(defaultValue: '')
  final String backgroundColor;
  @JsonKey(defaultValue: '')
  final String icon;
  @JsonKey(defaultValue: '')
  final String nameFallback;
  @JsonKey(defaultValue: '')
  final String descriptionFallback;

  factory Display.fromJson(Map<String, dynamic> json) =>
      _$DisplayFromJson(json);
  factory Display.emptyDisplay() => Display('', '', '', '');

  Display(this.backgroundColor, this.icon, this.nameFallback,
      this.descriptionFallback);

  Map<String, dynamic> toJson() => _$DisplayToJson(this);
}
