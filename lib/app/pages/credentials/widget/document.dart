import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/ecole_42_learning_achievement/ecole_42_learning_achievement.dart';
import 'package:talao/app/shared/model/loyalty_card/loyalty_card.dart';
import 'package:talao/app/shared/model/professional_student_card/professional_student_card.dart';
import 'package:talao/app/shared/model/voucher/voucher.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentWidget extends StatelessWidget {
  final CredentialModel model;

  const DocumentWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Professional Student Card, Loyalty Card and Voucher have aspecific display
    if (model.credentialPreview.credentialSubject is ProfessionalStudentCard) {
      return model.displayDetail(context, model);
    }
    if (model.credentialPreview.credentialSubject is LoyaltyCard) {
      return model.displayDetail(context, model);
    }
    if (model.credentialPreview.credentialSubject is Voucher) {
      return model.displayDetail(context, model);
    }
    if (model.credentialPreview.credentialSubject
        is Ecole42LearningAchievement) {
      final localizations = AppLocalizations.of(context)!;
      return Column(
        children: [
          model.displayDetail(context, model),
          if (model.credentialPreview.evidence.first.id != '')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '${localizations.evidenceLabel}: ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: InkWell(
                      onTap: () =>
                          _launchURL(model.credentialPreview.evidence.first.id),
                      child: Text(
                        '${model.credentialPreview.evidence.first.id.substring(0, 30)}...',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Theme.of(context).colorScheme.markDownA,
                              decoration: TextDecoration.underline,
                            ),
                        maxLines: 5,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.documentShadow,
            blurRadius: 2,
            spreadRadius: 1.0,
            offset: Offset(3, 3),
          )
        ],
      ),
      child: Container(
        decoration: BaseBoxDecoration(
          color: model.backgroundColor,
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 0.0,
          shapeSize: 256.0,
          anchors: <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
          // value: animation.value,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: displayCredentialDetail(context),
      ),
    );
  }

  Widget displayCredentialDetail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: model.displayDetail(context, model),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
