import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:talao/app/shared/model/display.dart';
import 'package:talao/app/shared/model/proof.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/translation.dart';

part 'credential.g.dart';

@JsonSerializable()
class Credential {
  final String id;
  final List<String> type;
  final String issuer;
  @JsonKey(fromJson: _fromJsonTranslations)
  final List<Translation> description;
  @JsonKey(defaultValue: [])
  final List<Translation> name;
  final String issuanceDate;
  @JsonKey(fromJson: _fromJsonProofs)
  final List<Proof> proof;
  final CredentialSubject credentialSubject;
  // @JsonKey(fromJson: _fromJsonScope)
  // final List<String> scope;
  @JsonKey(fromJson: fromJsonDisplay)
  final Display display;

  Credential(
      this.id,
      this.type,
      this.issuer,
      this.issuanceDate,
      this.proof,
      this.credentialSubject,
      this.description,
      this.name,
      // this.scope,
      this.display);

  factory Credential.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'VerifiableCredential') {
      return Credential.dummy();
    }
    return _$CredentialFromJson(json);
  }

  factory Credential.dummy() {
    return Credential(
        'dummy',
        ['dummy'],
        'dummy',
        'dummy',
        [
          Proof.dummy(),
        ],
        DefaultCredentialSubject('dummy', 'dummy', Author('', '')),
        [Translation('en', '')],
        [Translation('en', '')],
        // ['dummy'],
        Display(
          '',
          'dummy',
          'dummy',
          'dummy',
        ));
  }

  Map<String, dynamic> toJson() => _$CredentialToJson(this);

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
        credentialSubject.displayDetail(context, item),
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
        DisplayIssuer(issuer: credentialSubject.issuedBy)
      ],
    );
  }

  Widget displayName(BuildContext context) {
    final nameValue = getName(context, name);
    return Text(nameValue.toString(),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget displayDescription(BuildContext context) {
    final nameValue = getDescription(context, description);
    return Text(
      nameValue.toString(),
    );
  }

  static List<Proof> _fromJsonProofs(json) {
    if (json == null) {
      return [Proof.dummy()];
    }
    if (json is List) {
      return (json)
          .map((e) => Proof.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Proof.fromJson(json)];
  }

  // static List<String> _fromJsonScope(json) {
  //   if (json is List) {
  //     return (json)
  //         .map((e) => Proof.fromJson(e as Map<String, dynamic>))
  //         .toList();
  //   }
  //   return [Proof.fromJson(json)];
  //
  // }

  static List<Translation> _fromJsonTranslations(json) {
    if (json == null || json == '') {
      return [];
    }
    if (json is List) {
      return (json)
          .map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Translation.fromJson(json)];
  }

  static Credential fromJsonOrErrorPage(Map<String, dynamic> data) {
    try {
      return Credential.fromJson(data);
    } catch (e) {
      print(e.toString());
      Modular.to.pushNamed(
        '/error',
        arguments: e.toString(),
      );
      return Credential.dummy();
    }
  }

  static Credential fromJsonOrDummy(Map<String, dynamic> data) {
    try {
      return Credential.fromJson(data);
    } catch (e) {
      print(e.toString());
      return Credential.dummy();
    }
  }

  Color get backgroundColor {
    Color _backgroundColor;
    if (display.backgroundColor != '' && display.backgroundColor != null) {
      _backgroundColor =
          Color(int.parse(display.backgroundColor.substring(1), radix: 16));
    } else {
      _backgroundColor = credentialSubject.backgroundColor;
    }
    return _backgroundColor;
  }

  String getName(BuildContext context, List<Translation> translations) {
    final localizations = AppLocalizations.of(context)!;

    var _nameValue = getTranslation(translations, localizations);
    if (_nameValue == '') {
      _nameValue = display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = type.last;
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
    var toto = translations
        .where((element) => element.language == localizations.localeName);
    if (toto.isEmpty) {
      var titi = translations.where((element) => element.language == 'en');
      if (titi.isEmpty) {
        _translation = '';
      } else {
        _translation = titi.single.value;
      }
    } else {
      _translation = toto.single.value;
    }
    return _translation;
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
}
