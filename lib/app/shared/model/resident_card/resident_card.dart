import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'resident_card.g.dart';

@JsonSerializable()
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
    const double labelWidth = 80;

    return Column(
      children: [
        Container(child: Image.asset('assets/image/gov-light.png')),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: labelWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.lastName),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(familyName,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: labelWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      localizations.firstName,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(givenName,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: labelWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.gender),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: genderDisplay(),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(localizations.birthdate),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(birthDate,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(localizations.birthplace),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(birthPlace,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: labelWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.address),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(address,
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(localizations.maritalStatus),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(maritalStatus,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: labelWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.identifier),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(identifier,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(localizations.nationality),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(nationality,
                      style: TextStyle(
                          inherit: true, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
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
