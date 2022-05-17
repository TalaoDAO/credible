import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/certificate_of_employment/certificate_of_employment.dart';
import 'package:talao/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:talao/app/shared/model/ecole_42_learning_achievement/ecole_42_learning_achievement.dart';
import 'package:talao/app/shared/model/email_pass/email_pass.dart';
import 'package:talao/app/shared/model/identity_pass/identity_pass.dart';
import 'package:talao/app/shared/model/learning_achievement/learning_achievement.dart';
import 'package:talao/app/shared/model/loyalty_card/loyalty_card.dart';
import 'package:talao/app/shared/model/over18/over18.dart';
import 'package:talao/app/shared/model/phone_pass/phone_pass.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/professional_experience_assessment.dart';
import 'package:talao/app/shared/model/professional_skil_assessment/professional_skill_assessment.dart';
import 'package:talao/app/shared/model/professional_student_card/professional_student_card.dart';
import 'package:talao/app/shared/model/resident_card/resident_card.dart';
import 'package:talao/app/shared/model/student_card/student_card.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/model/voucher/voucher.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/app/shared/widget/hero_workaround.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/credential_container.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/credentials/widget/display_status.dart';
import 'package:talao/credentials/widget/list_item.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/self_issued_credential/models/self_issued.dart';

part 'credential_subject.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialSubject {
  final String id;
  final String type;
  @JsonKey(fromJson: fromJsonAuthor)
  final Author issuedBy;

  CredentialSubject(this.id, this.type, this.issuedBy);

  Color get backgroundColor {
    Color _backgroundColor;
    switch (type) {
      case 'ResidentCard':
        _backgroundColor = Colors.white;
        break;
      case 'SelfIssued':
        _backgroundColor = Color(0xffEFF0F6);
        break;
      case 'IdentityPass':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'Voucher':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'LoyaltyCard':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'Over18':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'ProfessionalStudentCard':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'CertificateOfEmployment':
        _backgroundColor = Color(0xFF9BF6FF);
        break;
      case 'EmailPass':
        _backgroundColor = Color(0xFFffD6A5);
        break;
      case 'PhonePass':
        _backgroundColor = Color(0xFFffD6A5);
        break;
      case 'ProfessionalExperienceAssessment':
        _backgroundColor = Color(0xFFFFADAD);
        break;
      case 'ProfessionalSkillAssessment':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'LearningAchievement':
        _backgroundColor = Color(0xFFFFADAD);
        break;
      default:
        _backgroundColor = Colors.white;
    }
    return _backgroundColor;
  }

  Icon get icon {
    Icon _icon;
    switch (type) {
      case 'ResidentCard':
        _icon = Icon(Icons.home);
        break;
      case 'IdentityPass':
        _icon = Icon(Icons.perm_identity);
        break;
      case 'Voucher':
        _icon = Icon(Icons.gamepad);
        break;
      case 'LoyaltyCard':
        _icon = Icon(Icons.loyalty);
        break;
      case 'Over18':
        _icon = Icon(Icons.accessible_rounded);
        break;
      case 'ProfessionalStudentCard':
        _icon = Icon(Icons.perm_identity);
        break;
      case 'CertificateOfEmployment':
        _icon = Icon(Icons.work);
        break;
      case 'EmailPass':
        _icon = Icon(Icons.mail);
        break;
      case 'PhonePass':
        _icon = Icon(Icons.phone);
        break;
      case 'ProfessionalExperienceAssessment':
        _icon = Icon(Icons.add_road_outlined);
        break;
      case 'ProfessionalSkillAssessment':
        _icon = Icon(Icons.assessment_outlined);
        break;
      case 'LearningAchievement':
        _icon = Icon(Icons.star_rate_outlined);
        break;
      default:
        _icon = Icon(Icons.fact_check_outlined);
    }
    return _icon;
  }

  Widget displayInList(BuildContext context, CredentialModel item) {
    final credential = Credential.fromJsonOrDummy(item.data);

    return CredentialContainer(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BaseBoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: item.backgroundColor,
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 1.0,
          anchors: <Alignment>[
            Alignment.bottomRight,
          ],
        ),
        child: Material(
          color: Theme.of(context).colorScheme.transparent,
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroFix(
                        tag: 'credential/${item.id}/icon',
                        child: CredentialIcon(credential: credential)),
                    SizedBox(height: 16.0),
                    DisplayStatus(item, false),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: displayName(context, item),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 48,
                            child: displayDescription(context, item)),
                      ),
                      DisplayIssuer(
                          issuer:
                              item.credentialPreview.credentialSubject.issuedBy)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CredentialContainer(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BaseBoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: item.backgroundColor,
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 1.0,
          anchors: <Alignment>[
            Alignment.bottomRight,
          ],
        ),
        child: Material(
          color: Theme.of(context).colorScheme.transparent,
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: displayName(context, item),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 48, child: displayDescription(context, item)),
                ),
                DisplayIssuer(
                    issuer: item.credentialPreview.credentialSubject.issuedBy)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: displayName(context, item),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: displayDescription(context, item),
          ),
          item.credentialPreview.evidence.first.id != ''
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        '${localizations.evidenceLabel}: ',
                        style: Theme.of(context).textTheme.credentialFieldTitle,
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () => LaunchUrl.launch(
                              item.credentialPreview.evidence.first.id),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  item.credentialPreview.evidence.first.id,
                                  style: Theme.of(context)
                                      .textTheme
                                      .credentialFieldDescription,
                                  maxLines: 5,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  factory CredentialSubject.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'ResidentCard':
        return ResidentCard.fromJson(json);
      case 'SelfIssued':
        return SelfIssued.fromJson(json);
      case 'IdentityPass':
        return IdentityPass.fromJson(json);
      case 'Voucher':
        return Voucher.fromJson(json);
      case 'Ecole42LearningAchievement':
        return Ecole42LearningAchievement.fromJson(json);
      case 'LoyaltyCard':
        return LoyaltyCard.fromJson(json);
      case 'Over18':
        return Over18.fromJson(json);
      case 'ProfessionalStudentCard':
        return ProfessionalStudentCard.fromJson(json);
      case 'StudentCard':
        return StudentCard.fromJson(json);
      case 'CertificateOfEmployment':
        return CertificateOfEmployment.fromJson(json);
      case 'EmailPass':
        return EmailPass.fromJson(json);
      case 'PhonePass':
        return PhonePass.fromJson(json);
      case 'ProfessionalExperienceAssessment':
        return ProfessionalExperienceAssessment.fromJson(json);
      case 'ProfessionalSkillAssessment':
        return ProfessionalSkillAssessment.fromJson(json);
      case 'LearningAchievement':
        return LearningAchievement.fromJson(json);
    }
    return DefaultCredentialSubject.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$CredentialSubjectToJson(this);

  static Author fromJsonAuthor(json) {
    if (json == null || json == '') {
      return Author('', '');
    }
    return Author.fromJson(json);
  }

  String getName(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    var _nameValue = getTranslation(item.credentialPreview.name, localizations);
    if (_nameValue == '') {
      _nameValue = item.display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = item.credentialPreview.type.last;
    }

    return _nameValue;
  }

  String getDescription(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    var _nameValue =
        getTranslation(item.credentialPreview.description, localizations);
    if (_nameValue == '') {
      _nameValue = item.display.descriptionFallback;
    }

    return _nameValue;
  }

  String getTranslation(
      List<Translation> translations, AppLocalizations localizations) {
    var _translation;
    var translated = translations
        .where((element) => element.language == localizations.localeName);
    if (translated.isEmpty) {
      var titi = translations.where((element) => element.language == 'en');
      if (titi.isEmpty) {
        _translation = '';
      } else {
        _translation = titi.single.value;
      }
    } else {
      _translation = translated.single.value;
    }
    return _translation;
  }

  Widget displayName(BuildContext context, CredentialModel item) {
    final nameValue = getName(context, item);
    return Text(
      nameValue.toString(),
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: Theme.of(context).textTheme.credentialTitle,
    );
  }

  Widget displayDescription(BuildContext context, CredentialModel item) {
    final nameValue = getDescription(context, item);
    return Text(
      nameValue,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.credentialDescription,
    );
  }
}
