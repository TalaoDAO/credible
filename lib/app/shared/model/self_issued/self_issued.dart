import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';

part 'self_issued.g.dart';

@JsonSerializable(explicitToJson: true)
class SelfIssued extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String telephone;
  @JsonKey(defaultValue: '')
  final String email;

  factory SelfIssued.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedFromJson(json);

  SelfIssued(this.id, this.type, this.address, this.familyName, this.givenName,
      this.telephone, this.email, this.issuedBy)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$SelfIssuedToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display self-issued data');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Center();
  }
}
