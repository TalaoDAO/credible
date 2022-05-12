import 'package:json_annotation/json_annotation.dart';

part 'image_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ImageObject {
  factory ImageObject.fromJson(Map<String, dynamic> json) =>
      _$ImageObjectFromJson(json);

  final String uri;
  final String? alt;

  ImageObject(this.uri, this.alt);

  Map<String, dynamic> toJson() => _$ImageObjectToJson(this);
}
