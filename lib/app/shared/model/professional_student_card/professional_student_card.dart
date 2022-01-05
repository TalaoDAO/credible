import 'dart:math';

import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/professional_student_card/professional_student_card_recipient.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'professional_student_card.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalStudentCard extends CredentialSubject {
  final ProfessionalStudentCardRecipient recipient;
  @JsonKey(defaultValue: '')
  final String expires;
  @override
  final Author issuedBy;
  @override
  final String id;
  @override
  final String type;

  factory ProfessionalStudentCard.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalStudentCardFromJson(json);

  ProfessionalStudentCard(
      this.recipient, this.expires, this.issuedBy, this.id, this.type)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$ProfessionalStudentCardToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
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
            child:
                JobStudentCardAnimation(recipient: recipient, expires: expires),
          ),
        )
      ],
    );
  }
}

class JobStudentCardAnimation extends StatefulWidget {
  const JobStudentCardAnimation({
    Key? key,
    required this.recipient,
    required this.expires,
  }) : super(key: key);

  final ProfessionalStudentCardRecipient recipient;
  final String expires;

  @override
  State<JobStudentCardAnimation> createState() =>
      _JobStudentCardAnimationState();
}

class _JobStudentCardAnimationState extends State<JobStudentCardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Widget _card;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      value: 1,
    );
    _card = JobStudentCardRecto(
        recipient: widget.recipient, expires: widget.expires);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await _animationController.reverse();
          setState(() {
            if (_card is JobStudentCardRecto) {
              _card = JobStudentCardVerso();
            } else {
              _card = JobStudentCardRecto(
                  recipient: widget.recipient, expires: widget.expires);
            }
          });
          await _animationController.forward();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform:
                  Matrix4.rotationX((1 - _animationController.value) * pi / 2),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(9, 9),
                      blurRadius: 10,
                      spreadRadius: 5.0,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: _card,
              ),
            );
          },
        ));
  }
}

class JobStudentCardVerso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/adecco_student_card_verso.png',
                ))),
        child: AspectRatio(

            /// this size comes from law publication about job student card specs
            aspectRatio: 508.67 / 319.67,
            child: Container(
              height: 319.67,
              width: 508.67,
            )));
  }
}

class JobStudentCardRecto extends StatelessWidget {
  const JobStudentCardRecto({
    Key? key,
    required this.recipient,
    required this.expires,
  }) : super(key: key);

  final ProfessionalStudentCardRecipient recipient;
  final String expires;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                'assets/image/adecco_student_card_recto.png',
              ))),
      child: AspectRatio(

          /// this size comes from law publication about job student card specs
          aspectRatio: 508.67 / 319.67,
          child: Container(
              height: 319.67,
              width: 508.67,
              child: CustomMultiChildLayout(
                delegate:
                    ProfessionalStudentCardDelegate(position: Offset.zero),
                children: [
                  LayoutId(
                      id: 'familyName',
                      child: ProfessionalStudentCardText(
                          text: recipient.familyName)),
                  LayoutId(
                    id: 'givenName',
                    child:
                        ProfessionalStudentCardText(text: recipient.givenName),
                  ),
                  LayoutId(
                    id: 'birthDate',
                    child: ProfessionalStudentCardText(
                        text: UiKit.displayDate(
                            localizations, recipient.birthDate)),
                  ),
                  LayoutId(
                    id: 'expires',
                    child: ProfessionalStudentCardText(
                        text: UiKit.displayDate(
                            localizations, recipient.birthDate)),
                  ),
                  LayoutId(
                    id: 'signature',
                    child: ProfessionalStudentCardText(text: 'missing field'),
                  ),
                  LayoutId(
                    id: 'image',
                    child: Container(child: Image.network(recipient.image)),
                  )
                ],
              ))),
    );
  }
}

class ProfessionalStudentCardText extends StatelessWidget {
  const ProfessionalStudentCardText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: MediaQuery.of(context).orientation == Orientation.landscape
            ? Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! *
                    MediaQuery.of(context).size.aspectRatio)
            : Theme.of(context).textTheme.bodyText2);
  }
}

class ProfessionalStudentCardDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  ProfessionalStudentCardDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
          'familyName', Offset(size.width * 0.14, size.height * 0.28));
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.19, size.height * 0.38));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.19, size.height * 0.47));
    }

    if (hasChild('expires')) {
      layoutChild('expires', BoxConstraints.loose(size));
      positionChild('expires', Offset(size.width * 0.22, size.height * 0.56));
    }

    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.11, size.height * 0.75));
    }

    if (hasChild('image')) {
      layoutChild(
          'image',
          BoxConstraints.tightFor(
              width: size.width * 0.28, height: size.height * 0.59));
      positionChild('image', Offset(size.width * 0.68, size.height * 0.06));
    }
  }

  @override
  bool shouldRelayout(ProfessionalStudentCardDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
