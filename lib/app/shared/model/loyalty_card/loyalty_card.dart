import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'loyalty_card.g.dart';

@JsonSerializable(explicitToJson: true)
class LoyaltyCard extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String familyName;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String birthDate;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String programName;
  @JsonKey(defaultValue: '')
  final String telephone;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardFromJson(json);

  LoyaltyCard(this.id, this.type, this.address, this.familyName, this.issuedBy, this.birthDate, this.givenName, this.programName, this.telephone,) 
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$LoyaltyCardToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display Loyalty card');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    const labelWidth = 80.0;

    return Column(
      children: [
        DisplayIssuer(issuer: issuedBy),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoyaltyCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.lastName),
                value: TextWithLoyaltyCardStyle(value: familyName)),
            LoyaltyCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.firstName),
                value: TextWithLoyaltyCardStyle(value: givenName)),
            LoyaltyCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.birthdate),
                value: TextWithLoyaltyCardStyle(value: birthDate)),
            LoyaltyCardFieldDisplay(
                labelWidth: labelWidth,
                label: Text(localizations.address),
                value: TextWithLoyaltyCardStyle(value: address)),
          ],
        ),
      ],
    );
  }

}

class LoyaltyCardFieldDisplay extends StatelessWidget {
  const LoyaltyCardFieldDisplay({
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

class TextWithLoyaltyCardStyle extends StatelessWidget {
  const TextWithLoyaltyCardStyle({
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
