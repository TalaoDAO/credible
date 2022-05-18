import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/shared/enum/credential_status.dart';
import 'package:talao/app/shared/enum/revokation_status.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/display.dart';
import 'package:talao/credential_manifest/models/credential_manifest.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
//ignore: must_be_immutable
class CredentialModel extends Equatable {
  @JsonKey(fromJson: fromJsonId)
  final String id;
  final String? alias;
  final String? image;
  final Map<String, dynamic> data;
  @JsonKey(defaultValue: '')
  final String shareLink;
  final Credential credentialPreview;
  @JsonKey(fromJson: fromJsonDisplay)
  final Display display;
  final String? expirationDate;
  @JsonKey(defaultValue: RevocationStatus.unknown)
  RevocationStatus revocationStatus;
  @JsonKey(name: 'credential_manifest')
  final CredentialManifest? credentialManifest;

  // @JsonKey(fromJson: fromJsonDisplay)
  // final Scope display;

  CredentialModel({
    required this.id,
    required this.alias,
    required this.image,
    required this.credentialPreview,
    required this.shareLink,
    required this.display,
    required this.data,
    required this.revocationStatus,
    this.expirationDate,
    this.credentialManifest,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    // ignore: omit_local_variable_types
    final Map<String, dynamic> newJson = Map.from(json);
    if (newJson['data'] != null) {
      newJson.putIfAbsent('credentialPreview', () => newJson['data']);
    }
    if (newJson['credentialPreview'] != null) {
      newJson.putIfAbsent('data', () => newJson['credentialPreview']);
    }

    return _$CredentialModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$CredentialModelToJson(this);

  String get issuer => data['issuer']!;

  Future<CredentialStatus> get status async {
    if (expirationDate != null) {
      DateTime? dateTimeExpirationDate = DateTime.parse(expirationDate!);
      if (!(dateTimeExpirationDate.isAfter(DateTime.now()))) {
        revocationStatus = RevocationStatus.expired;
        return CredentialStatus.expired;
      }
    }
    if (credentialPreview.credentialStatus.type != '') {
      return await checkRevocationStatus();
    } else {
      return CredentialStatus.active;
    }
  }

  factory CredentialModel.copyWithAlias(
      {required CredentialModel oldCredentialModel,
      required String? newAlias}) {
    return CredentialModel(
      id: oldCredentialModel.id,
      alias: newAlias ?? '',
      image: oldCredentialModel.image,
      data: oldCredentialModel.data,
      shareLink: oldCredentialModel.shareLink,
      display: oldCredentialModel.display,
      credentialPreview: oldCredentialModel.credentialPreview,
      revocationStatus: oldCredentialModel.revocationStatus,
      expirationDate: oldCredentialModel.expirationDate,
      credentialManifest: oldCredentialModel.credentialManifest,
    );
  }

  factory CredentialModel.copyWithData(
      {required CredentialModel oldCredentialModel,
      required Map<String, dynamic> newData}) {
    return CredentialModel(
      id: oldCredentialModel.id,
      alias: oldCredentialModel.alias,
      image: oldCredentialModel.image,
      data: newData,
      shareLink: oldCredentialModel.shareLink,
      display: oldCredentialModel.display,
      credentialPreview: Credential.fromJson(newData),
      revocationStatus: oldCredentialModel.revocationStatus,
      expirationDate: oldCredentialModel.expirationDate,
      credentialManifest: oldCredentialModel.credentialManifest,
    );
  }

  static String fromJsonId(json) {
    if (json == null || json == '') {
      return Uuid().v4();
    } else {
      return json;
    }
  }

  static Display fromJsonDisplay(json) {
    if (json == null || json == '') {
      return Display(
        '',
        '',
        '',
        '',
      );
    }
    return Display.fromJson(json);
  }

  Color get backgroundColor {
    Color _backgroundColor;
    if (display.backgroundColor != '') {
      _backgroundColor =
          Color(int.parse('FF${display.backgroundColor}', radix: 16));
    } else {
      _backgroundColor = credentialPreview.credentialSubject.backgroundColor;
    }
    return _backgroundColor;
  }

  Future<CredentialStatus> checkRevocationStatus() async {
    switch (revocationStatus) {
      case RevocationStatus.active:
        return CredentialStatus.active;
      case RevocationStatus.expired:
        revocationStatus = RevocationStatus.expired;
        return CredentialStatus.expired;
      case RevocationStatus.revoked:
        return CredentialStatus.revoked;
      case RevocationStatus.unknown:
        var _status = await getRevocationStatus();
        switch (_status) {
          case RevocationStatus.active:
            return CredentialStatus.active;
          case RevocationStatus.expired:
            return CredentialStatus.expired;
          case RevocationStatus.revoked:
            return CredentialStatus.revoked;
          case RevocationStatus.unknown:
            throw Exception('Invalid status of credential');
        }
      default:
        throw Exception();
    }
  }

  Future<RevocationStatus> getRevocationStatus() async {
    final vcStr = jsonEncode(data);
    final optStr = jsonEncode({
      'checks': ['credentialStatus']
    });
    final result = await Future.any([
      DIDKitProvider.instance.verifyCredential(vcStr, optStr),
      Future.delayed(const Duration(seconds: 4))
    ]);
    if (result == null) return RevocationStatus.active;
    final jsonResult = jsonDecode(result);
    if (jsonResult['errors']?[0] == 'Credential is revoked.') {
      revocationStatus = RevocationStatus.revoked;
      return RevocationStatus.revoked;
    } else {
      revocationStatus = RevocationStatus.active;
      return RevocationStatus.active;
    }
  }

  void setRevocationStatusToUnknown() {
    revocationStatus = RevocationStatus.unknown;
    print('revocation status: $revocationStatus');
  }

  @override
  List<Object?> get props => [
        id,
        alias,
        image,
        data,
        shareLink,
        credentialPreview,
        display,
        revocationStatus
      ];
}
