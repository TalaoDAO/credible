import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String logo;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Author(this.name, this.logo);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
