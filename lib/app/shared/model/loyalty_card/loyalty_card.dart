import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/card_animation.dart';

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
  @JsonKey(defaultValue: '')
  final String email;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardFromJson(json);

  LoyaltyCard(
    this.id,
    this.type,
    this.address,
    this.familyName,
    this.issuedBy,
    this.birthDate,
    this.givenName,
    this.programName,
    this.telephone,
    this.email,
  ) : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$LoyaltyCardToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display Loyalty card');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(

            /// this size comes from law publication about job student card specs
            aspectRatio: 508.67 / 319.67,
            child: Container(
              height: 319.67,
              width: 508.67,
              child: CardAnimation(
                recto: LoyaltyCardRecto(),
                verso: LoyaltyCardVerso(this),
              ),
            )),
      ],
    );
  }
}

class LoyaltyCardRecto extends Recto {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/tezotopia_loyalty_card.jpeg',
                ))),
        child: AspectRatio(

            /// random size, copy from professional student card
            aspectRatio: 508.67 / 319.67,
            child: Container(
              height: 319.67,
              width: 508.67,
            )));
  }
}

class LoyaltyCardVerso extends Verso {
  final LoyaltyCard loyaltyCard;

  LoyaltyCardVerso(this.loyaltyCard);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.red,
      ),
      child: Column(
        children: [
          TextWithLoyaltyCardStyle(value: loyaltyCard.programName),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWithLoyaltyCardStyle(value: loyaltyCard.givenName),
                TextWithLoyaltyCardStyle(value: loyaltyCard.familyName),
              ],
            ),
          ),
          TextWithLoyaltyCardStyle(
              value: UiDate.displayDate(localizations, loyaltyCard.birthDate)),
          TextWithLoyaltyCardStyle(value: loyaltyCard.email),
          TextWithLoyaltyCardStyle(value: loyaltyCard.telephone),
          TextWithLoyaltyCardStyle(value: loyaltyCard.address),
        ],
      ),
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
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value,
            style: Theme.of(context).textTheme.loyaltyCard),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
