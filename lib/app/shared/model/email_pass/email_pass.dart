import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_pass.g.dart';

@JsonSerializable()
class EmailPass extends CredentialSubject {
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String id;
  @override
  final String type;

  factory EmailPass.fromJson(Map<String, dynamic> json) =>
      _$EmailPassFromJson(json);

  EmailPass(this.expires, this.email, this.id, this.type) : super(id, type);

  @override
  Map<String, dynamic> toJson() => _$EmailPassToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(id),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(expires),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(email),
        ),
      ],
    );
  }
}
