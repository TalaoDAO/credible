import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/shared/enum/credential_status.dart';
import 'package:talao/app/shared/enum/revokation_status.dart';
import 'package:talao/app/shared/model/credential_status_field.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/certificate_of_employment/certificate_of_employment.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/display.dart';
import 'package:talao/app/shared/model/ecole_42_learning_achievement/ecole_42_learning_achievement.dart';
import 'package:talao/app/shared/model/loyalty_card/loyalty_card.dart';
import 'package:talao/app/shared/model/professional_student_card/professional_student_card.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/model/voucher/voucher.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  @JsonKey(defaultValue: RevocationStatus.unknown)
  RevocationStatus revocationStatus;

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
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    // ignore: omit_local_variable_types
    Map<String, dynamic> newJson = Map.from(json);
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

  DateTime? get expirationDate => (data['expirationDate'] != null)
      ? DateTime.parse(data['expirationDate'])
      : null;

  Future<CredentialStatus> get status async {
    if (expirationDate != null) {
      if (!(expirationDate!.isAfter(DateTime.now()))) {
        revocationStatus = RevocationStatus.expired;
        return CredentialStatus.expired;
      }
    }
    if (credentialPreview.credentialStatus !=
        CredentialStatusField.emptyCredentialStatusField()) {
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

  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    final _issuanceDate = credentialPreview.issuanceDate;

    /// Professional Student Card, Voucher and Loyalty Card have both aspecific display
    if (credentialPreview.credentialSubject is ProfessionalStudentCard) {
      return credentialPreview.credentialSubject.displayDetail(context, item);
    }
    if (credentialPreview.credentialSubject is LoyaltyCard) {
      return credentialPreview.credentialSubject.displayDetail(context, item);
    }
    if (credentialPreview.credentialSubject is Voucher) {
      return credentialPreview.credentialSubject.displayDetail(context, item);
    }
    if (credentialPreview.credentialSubject is Ecole42LearningAchievement) {
      return credentialPreview.credentialSubject.displayDetail(context, item);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: displayName(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: displayDescription(context),
        ),
        credentialPreview.credentialSubject.displayDetail(context, item),
        credentialPreview.credentialSubject is CertificateOfEmployment
            ? CredentialField(
                value: UiDate.displayDate(localizations, _issuanceDate),
                // value: _issuanceDate.toString(),
                title: localizations.issuanceDate)
            : SizedBox.shrink(),
        credentialPreview.evidence.first.id != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      '${localizations.evidenceLabel}: ',
                      style: Theme.of(context).textTheme.credentialFieldTitle,
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () =>
                            _launchURL(credentialPreview.evidence.first.id),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                credentialPreview.evidence.first.id,
                                style: Theme.of(context)
                                    .textTheme
                                    .credentialFieldDescription,
                                maxLines: 5,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }

  Widget displayList(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: displayName(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(height: 48, child: displayDescription(context)),
        ),
        DisplayIssuer(issuer: credentialPreview.credentialSubject.issuedBy)
      ],
    );
  }

  String getName(BuildContext context, List<Translation> translations) {
    final localizations = AppLocalizations.of(context)!;

    var _nameValue = getTranslation(translations, localizations);
    if (_nameValue == '') {
      _nameValue = display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = credentialPreview.type.last;
    }

    return _nameValue;
  }

  String getDescription(BuildContext context, List<Translation> translations) {
    final localizations = AppLocalizations.of(context)!;

    var _nameValue = getTranslation(translations, localizations);
    if (_nameValue == '') {
      _nameValue = display.descriptionFallback;
    }

    return _nameValue;
  }

  String getTranslation(
      List<Translation> translations, AppLocalizations localizations) {
    var _translation;
    var translated = translations
        .where((element) => element.language == localizations.localeName);
    if (translated.isEmpty) {
      var titi = translations.where((element) => element.language == 'en');
      if (titi.isEmpty) {
        _translation = '';
      } else {
        _translation = titi.single.value;
      }
    } else {
      _translation = translated.single.value;
    }
    return _translation;
  }

  Widget displayName(BuildContext context) {
    final nameValue = getName(context, credentialPreview.name);
    return Text(
      nameValue.toString(),
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: Theme.of(context).textTheme.credentialTitle,
    );
  }

  Widget displayDescription(BuildContext context) {
    final nameValue = getDescription(context, credentialPreview.description);
    return Text(
      nameValue,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.credentialDescription,
    );
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

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

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
