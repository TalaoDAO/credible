import 'package:flutter/material.dart';
import 'package:talao/app/pages/credentials/models/credential_status.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/display.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'credential.g.dart';

@JsonSerializable()
class CredentialModel {
  @JsonKey(fromJson: fromJsonId)
  final String id;
  final String? alias;
  final String? image;
  final Map<String, dynamic> data;
  @JsonKey(defaultValue: '')
  final String shareLink;
  @JsonKey(fromJson: fromJsonDisplay)
  final Display display;
  final Credential credentialPreview;
  // @JsonKey(fromJson: fromJsonDisplay)
  // final Scope display;

  CredentialModel(
      {required this.id,
      required this.alias,
      required this.image,
      required this.credentialPreview,
      required this.shareLink,
      required this.display,
      required this.data});
  factory CredentialModel.fromJson(Map<String, dynamic> json) {
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

  CredentialStatus get status {
    if (expirationDate == null) {
      return CredentialStatus.active;
    }

    return expirationDate!.isAfter(DateTime.now())
        ? CredentialStatus.active
        : CredentialStatus.expired;
  }

  factory CredentialModel.copyWithAlias(
      {required CredentialModel oldCredentialModel, required String newAlias}) {
    return CredentialModel(
      id: oldCredentialModel.id,
      alias: newAlias,
      image: oldCredentialModel.image,
      data: oldCredentialModel.data,
      shareLink: oldCredentialModel.shareLink,
      display: oldCredentialModel.display,
      credentialPreview: oldCredentialModel.credentialPreview,
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
    if (display.backgroundColor != '' && display.backgroundColor != null) {
      _backgroundColor =
          Color(int.parse(display.backgroundColor.substring(1), radix: 16));
    } else {
      _backgroundColor = credentialPreview.credentialSubject.backgroundColor;
    }
    return _backgroundColor;
  }

  Widget displayDetail(BuildContext context, CredentialModel item) {
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
          child: displayDescription(context),
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
    return Text(nameValue.toString(),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget displayDescription(BuildContext context) {
    final nameValue = getDescription(context, credentialPreview.description);
    return Text(
      nameValue.toString(),
    );
  }
}
