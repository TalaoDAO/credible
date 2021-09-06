import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable()
class Translation {
  @JsonKey(defaultValue: 'en', name: '@language')
  final String language;
  @JsonKey(defaultValue: '', name: '@value')
  final String value;

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  Translation(this.language, this.value);

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
