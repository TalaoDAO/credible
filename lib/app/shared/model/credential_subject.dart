import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/certificate_of_employment/certificate_of_employment.dart';
import 'package:talao/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:talao/app/shared/model/email_pass/email_pass.dart';
import 'package:talao/app/shared/model/identity_pass/identity_pass.dart';
import 'package:talao/app/shared/model/learning_achievement/learning_achievement.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/professional_experience_assessment.dart';
import 'package:talao/app/shared/model/resident_card/resident_card.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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
      case 'IdentityPass':
        _backgroundColor = Color(0xffCAFFBF);
        break;
      case 'CertificateOfEmployment':
        _backgroundColor = Color(0xFF9BF6FF);
        break;
      case 'EmailPass':
        _backgroundColor = Color(0xFFffD6A5);
        break;
      case 'ProfessionalExperienceAssessment':
        _backgroundColor = Color(0xFFFFADAD);
        break;
      case 'LearningAchievement':
        _backgroundColor = Color(0xFFFFADAD);
        break;
      default:
        _backgroundColor = UiKit.palette.credentialBackground;
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
      case 'CertificateOfEmployment':
        _icon = Icon(Icons.work);
        break;
      case 'EmailPass':
        _icon = Icon(Icons.mail);
        break;
      case 'ProfessionalExperienceAssessment':
        _icon = Icon(Icons.add_road_outlined);
        break;
      case 'LearningAchievement':
        _icon = Icon(Icons.star_rate_outlined);
        break;
      default:
        _icon = Icon(Icons.device_unknown_sharp);
    }
    return _icon;
  }

  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('first display');
  }

  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Text('first display');
  }

  factory CredentialSubject.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'ResidentCard':
        return ResidentCard.fromJson(json);
      case 'IdentityPass':
        return IdentityPass.fromJson(json);
      case 'CertificateOfEmployment':
        return CertificateOfEmployment.fromJson(json);
      case 'EmailPass':
        return EmailPass.fromJson(json);
      case 'ProfessionalExperienceAssessment':
        return ProfessionalExperienceAssessment.fromJson(json);
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
}
