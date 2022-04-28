import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_credential_subject.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCredentialSubject extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  factory DefaultCredentialSubject.fromJson(Map<String, dynamic> json) =>
      _$DefaultCredentialSubjectFromJson(json);

  DefaultCredentialSubject(this.id, this.type, this.issuedBy)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$DefaultCredentialSubjectToJson(this);
}
