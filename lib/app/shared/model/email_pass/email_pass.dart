import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/card_animation.dart';
import 'package:talao/app/shared/widget/display_description_card.dart';
import 'package:talao/app/shared/widget/display_name_card.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class EmailPass extends CredentialSubject {
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String passbaseMetadata;

  factory EmailPass.fromJson(Map<String, dynamic> json) =>
      _$EmailPassFromJson(json);

  EmailPass(this.expires, this.email, this.id, this.type, this.issuedBy,
      this.passbaseMetadata)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$EmailPassToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return EmailPassRecto(item);
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return EmailPassRecto(item);
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
              child: CardAnimation(
                  recto: EmailPassRecto(item), verso: EmailPassVerso(item)),
            )),
      ],
    );
  }
}

class EmailPassRecto extends Recto {
  EmailPassRecto(this.item);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/email_pass_verso.png',
                ))),
        child: AspectRatio(

            /// size from over18 recto picture
            aspectRatio: 584 / 317,
            child: Container(
              height: 317,
              width: 584,
              child: CustomMultiChildLayout(
                delegate: EmailPassVersoDelegate(position: Offset.zero),
                children: [
                  LayoutId(
                    id: 'name',
                    child: DisplayNameCard(
                      item,
                      Theme.of(context).textTheme.credentialTitleCard,
                    ),
                  ),
                  LayoutId(
                    id: 'description',
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 250 * MediaQuery.of(context).size.aspectRatio),
                      child: DisplayDescriptionCard(
                        item,
                        Theme.of(context).textTheme.credentialTextCard,
                      ),
                    ),
                  ),
                  LayoutId(
                    id: 'issuer',
                    child: Row(
                      children: [
                        Container(
                            height: 30,
                            child: ImageFromNetwork(
                              item.credentialPreview.credentialSubject.issuedBy
                                  .logo,
                              fit: BoxFit.cover,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

class EmailPassVerso extends Verso {
  EmailPassVerso(this.item);
  final CredentialModel item;
  @override
  Widget build(BuildContext context) {
    final credentialSubject = item.credentialPreview.credentialSubject;
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/email_pass_verso.png',
                ))),
        child: AspectRatio(

            /// size from over18 recto picture
            aspectRatio: 584 / 317,
            child: Container(
              height: 317,
              width: 584,
              child: CustomMultiChildLayout(
                delegate: EmailPassVersoDelegate(position: Offset.zero),
                children: [
                  LayoutId(
                    id: 'name',
                    child: DisplayNameCard(
                      item,
                      Theme.of(context).textTheme.credentialTitleCard,
                    ),
                  ),
                  LayoutId(
                    id: 'description',
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 250 * MediaQuery.of(context).size.aspectRatio),
                      child: DisplayDescriptionCard(
                          item, Theme.of(context).textTheme.credentialTextCard),
                    ),
                  ),
                  LayoutId(
                    id: 'issuer',
                    child: Row(
                      children: [
                        Container(
                            height: 30,
                            child: ImageFromNetwork(
                              item.credentialPreview.credentialSubject.issuedBy
                                  .logo,
                              fit: BoxFit.cover,
                            )),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            credentialSubject is EmailPass
                                ? Text(
                                    credentialSubject.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .credentialTextCard,
                                  )
                                : SizedBox.shrink(),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

class EmailPassVersoDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  EmailPassVersoDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.14));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
          'description', Offset(size.width * 0.06, size.height * 0.33));
    }

    if (hasChild('issuer')) {
      layoutChild('issuer', BoxConstraints.loose(size));
      positionChild('issuer', Offset(size.width * 0.06, size.height * 0.783));
    }
  }

  @override
  bool shouldRelayout(EmailPassVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
