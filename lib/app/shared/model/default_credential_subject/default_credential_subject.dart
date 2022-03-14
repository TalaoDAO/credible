import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

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

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        CredentialField(value: type),
        CredentialField(value: issuedBy.name),
      ],
    );
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DisplayIssuer(
            issuer: issuedBy,
          ),
        ],
      ),
    );
  }
}
