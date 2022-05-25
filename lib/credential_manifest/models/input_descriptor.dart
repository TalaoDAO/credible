import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/constraints.dart';

part 'input_descriptor.g.dart';

@JsonSerializable(explicitToJson: true)
class InputDescriptor {
  factory InputDescriptor.fromJson(Map<String, dynamic> json) =>
      _$InputDescriptorFromJson(json);

  final Constraints? constraints;

  InputDescriptor(this.constraints);

  Map<String, dynamic> toJson() => _$InputDescriptorToJson(this);
}
