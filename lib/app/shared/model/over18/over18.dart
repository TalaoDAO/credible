import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/date.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/card_animation.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'over18.g.dart';

@JsonSerializable(explicitToJson: true)
class Over18 extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  factory Over18.fromJson(Map<String, dynamic> json) => _$Over18FromJson(json);

  Over18(this.id, this.type, this.issuedBy) : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$Over18ToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(
            aspectRatio: 584 / 317,
            child: Container(
              height: 317,
              width: 584,
              child:
                  CardAnimation(recto: Over18Recto(), verso: Over18Verso(item)),
            )),
      ],
    );
  }
}

class Over18Verso extends Verso {
  Over18Verso(this.item);
  final CredentialModel item;
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final expirationDate = item.expirationDate;
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/over18_verso.png',
                ))),
        child: AspectRatio(

            /// size from over18 recto picture
            aspectRatio: 584 / 317,
            child: Container(
              height: 317,
              width: 584,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24, left: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 50,
                          child: ImageFromNetwork(
                            item.credentialPreview.credentialSubject.issuedBy
                                .logo,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  (expirationDate != null)
                      ? TextWithOver18CardStyle(
                          value:
                              '${localizations.expires}: ${UiDate.displayDate(localizations, expirationDate)}',
                        )
                      : SizedBox.shrink(),
                  TextWithOver18CardStyle(
                    value:
                        '${localizations.issuer}: ${item.credentialPreview.credentialSubject.issuedBy.name}',
                  ),
                ],
              ),
            )));
  }
}

class Over18Recto extends Recto {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/over18_recto.png',
                ))),
        child: AspectRatio(

            /// size from over18 recto picture
            aspectRatio: 584 / 317,
            child: Container(
              height: 317,
              width: 584,
            )));
  }
}

class TextWithOver18CardStyle extends StatelessWidget {
  const TextWithOver18CardStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(value, style: Theme.of(context).textTheme.over18),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
