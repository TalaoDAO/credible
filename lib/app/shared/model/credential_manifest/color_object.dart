import 'package:json_annotation/json_annotation.dart';

part 'color_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ColorObject {
  factory ColorObject.fromJson(Map<String, dynamic> json) =>
      _$ColorObjectFromJson(json);

  final String? color;

  ColorObject(this.color);

  Map<String, dynamic> toJson() => _$ColorObjectToJson(this);
}
