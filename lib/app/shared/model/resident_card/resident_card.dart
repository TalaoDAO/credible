import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

part 'resident_card.g.dart';

@JsonSerializable(explicitToJson: true)
class ResidentCard extends CredentialSubject {
  @override
  final String id;
  @JsonKey(defaultValue: '')
  final String gender;
  @JsonKey(defaultValue: '')
  final String maritalStatus;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String birthPlace;
  @JsonKey(defaultValue: '')
  final String nationality;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String identifier;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String image;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String birthDate;
  @JsonKey(defaultValue: '')
  final String givenName;

  factory ResidentCard.fromJson(Map<String, dynamic> json) =>
      _$ResidentCardFromJson(json);

  ResidentCard(
      this.id,
      this.gender,
      this.maritalStatus,
      this.type,
      this.birthPlace,
      this.nationality,
      this.address,
      this.identifier,
      this.familyName,
      this.image,
      this.issuedBy,
      this.birthDate,
      this.givenName)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$ResidentCardToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        DisplayIssuer(issuer: issuedBy),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CredentialField(title: localizations.lastName, value: familyName),
            CredentialField(title: localizations.firstName, value: givenName),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${localizations.gender}: ',
                    style: Theme.of(context).textTheme.credentialFieldTitle,
                  ),
                  Flexible(
                    child: genderDisplay(context),
                  ),
                ],
              ),
            ),
            CredentialField(
                title: localizations.birthdate,
                value: UiDate.displayDate(localizations, birthDate)),
            CredentialField(title: localizations.birthplace, value: birthPlace),
            CredentialField(title: localizations.address, value: address),
            CredentialField(
                title: localizations.maritalStatus, value: maritalStatus),
            CredentialField(title: localizations.identifier, value: identifier),
            CredentialField(
                title: localizations.nationality, value: nationality),
          ],
        ),
      ],
    );
  }

  Widget genderDisplay(BuildContext context) {
    Widget _genderIcon;
    switch (gender) {
      case 'male':
        _genderIcon =
            Icon(Icons.male, color: Theme.of(context).colorScheme.genderIcon);
        break;
      case 'female':
        _genderIcon =
            Icon(Icons.female, color: Theme.of(context).colorScheme.genderIcon);
        break;
      default:
        _genderIcon = Icon(Icons.transgender,
            color: Theme.of(context).colorScheme.genderIcon);
    }
    return _genderIcon;
  }
}
