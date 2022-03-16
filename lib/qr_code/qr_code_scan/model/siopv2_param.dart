import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'siopv2_param.g.dart';

@JsonSerializable()
class SIOPV2Param extends Equatable {
  SIOPV2Param({
    this.nonce,
    this.request_uri,
    this.claims,
  });

  final String? nonce;
  final String? request_uri;
  final String? claims;

  factory SIOPV2Param.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2ParamFromJson(json);

  Map<String, dynamic> toJson() => _$SIOPV2ParamToJson(this);

  @override
  List<Object?> get props => [nonce, request_uri, claims];
}
