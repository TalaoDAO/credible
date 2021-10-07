import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    const labelWidth = 80.0;

    return Column(
      children: [
        Container(child: Image.asset('assets/image/gov-light.png')),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.lastName),
                value: TextWithResidentCardStyle(value: familyName)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.firstName),
                value: TextWithResidentCardStyle(value: givenName)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.gender),
                value: genderDisplay()),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.birthdate),
                value: TextWithResidentCardStyle(value: birthDate)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.birthplace),
                value: TextWithResidentCardStyle(value: birthPlace)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.address),
                value: TextWithResidentCardStyle(value: address)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.maritalStatus),
                value: TextWithResidentCardStyle(value: maritalStatus)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.identifier),
                value: TextWithResidentCardStyle(value: identifier)),
            ResidentCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.nationality),
                value: TextWithResidentCardStyle(value: nationality)),
          ],
        ),
      ],
    );
  }

  Widget genderDisplay() {
    Widget _genderIcon;
    switch (gender) {
      case 'male':
        _genderIcon = Icon(Icons.male);
        break;
      case 'female':
        _genderIcon = Icon(Icons.female);
        break;
      default:
        _genderIcon = Icon(Icons.transgender);
    }
    return _genderIcon;
  }
}

class ResidentCardFieldDisplay extends StatelessWidget {
  const ResidentCardFieldDisplay({
    Key? key,
    required this.labelWidth,
    required this.label,
    required this.value,
  }) : super(key: key);

  final double labelWidth;
  final Widget label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: BoxConstraints(minWidth: labelWidth),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: label,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: value,
          ),
        ),
      ],
    );
  }
}

class TextWithResidentCardStyle extends StatelessWidget {
  const TextWithResidentCardStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(value,
        style: TextStyle(inherit: true, fontWeight: FontWeight.w700));
  }
}
