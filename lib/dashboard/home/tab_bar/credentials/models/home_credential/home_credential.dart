import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeCredential extends Equatable {
  const HomeCredential({
    this.credentialModel,
    this.link,
    this.image,
    required this.isDummy,
    this.dummyDescription,
    required this.credentialSubjectType,
    this.websiteGameLink,
    this.whyGetThisCard,
    this.expirationDateDetails,
    this.howToGetIt,
  });

  factory HomeCredential.fromJson(Map<String, dynamic> json) =>
      _$HomeCredentialFromJson(json);

  factory HomeCredential.isNotDummy(CredentialModel credentialModel) {
    return HomeCredential(
      credentialModel: credentialModel,
      isDummy: false,
      credentialSubjectType: credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType,
    );
  }

  factory HomeCredential.isDummy(CredentialSubjectType credentialSubjectType) {
    String? image;
    String? link;
    String? websiteGameLink;
    ResponseString? whyGetThisCard;
    ResponseString? expirationDateDetails;
    ResponseString? howToGetIt;
    ResponseString? dummyDesc;

    switch (credentialSubjectType) {
      case CredentialSubjectType.deviceInfo:
      case CredentialSubjectType.ageRange:
        image = ImageStrings.dummyAgeRangeCard;
        link = Urls.ageRangeUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_ageRangeExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_ageRangeHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_ageRangeProofDummyDescription;
        break;

      case CredentialSubjectType.nationality:
        image = ImageStrings.dummyNationalityCard;
        link = Urls.nationalityUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_nationalityExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_nationalityHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_nationalityProofDummyDescription;
        break;

      case CredentialSubjectType.gender:
        image = ImageStrings.dummyGenderCard;
        link = Urls.genderUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_genderWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_genderExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_genderHowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_genderProofDummyDescription;
        break;

      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;
        dummyDesc = ResponseString.RESPONSE_STRING_emailProofDummyDescription;
        link = Urls.emailPassUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_emailPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_emailPassHowToGetIt;
        break;

      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_over18DummyDescription;
        break;

      case CredentialSubjectType.over13:
        image = ImageStrings.dummyOver13Card;
        link = Urls.over13Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over13WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over13ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over13HowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_over13DummyDescription;
        break;

      case CredentialSubjectType.passportFootprint:
        image = ImageStrings.dummyPassportFootprintCard;
        link = Urls.passportFootprintUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_passportFootprintExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_passportFootprintDummyDescription;
        break;

      case CredentialSubjectType.tezVoucher:
        image = ImageStrings.dummyTezotopiaVoucherCard;
        link = Urls.tezotopiaVoucherUrl;
        websiteGameLink = 'https://tezotopia.com';
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tezVoucherExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt;
        break;

      case CredentialSubjectType.talaoCommunityCard:
        image = ImageStrings.dummyTalaoCommunityCardCard;
        link = Urls.talaoCommunityCardUrl;
        break;

      case CredentialSubjectType.identityCard:
        image = ImageStrings.dummyIdentityCard;
        link = Urls.identityCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_identityCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_identityCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_identityCardHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_identityProofDummyDescription;
        break;

      case CredentialSubjectType.tezotopiaMembership:
        image = ImageStrings.tezotopiaMemberShipDummy;
        link = Urls.tezotopiaMembershipCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipExpirationDate;
        howToGetIt =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipHowToGetIt;
        break;

      case CredentialSubjectType.chainbornMembership:
        image = ImageStrings.chainbornMemberShipDummy;
        link = Urls.chainbornMembershipCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_chainbornMembershipWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_chainbornMembershipExpirationDate;
        howToGetIt =
            ResponseString.RESPONSE_STRING_chainbornMembershipHowToGetIt;
        break;

      case CredentialSubjectType.bunnyPass:
        image = ImageStrings.bunnyPassDummy;
        link = Urls.bunnyPassCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_bunnyPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_bunnyPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_bunnyPassHowToGetIt;
        break;

      case CredentialSubjectType.dogamiPass:
        image = ImageStrings.dogamiPassDummy;
        link = Urls.dogamiPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_dogamiPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_dogamiPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_dogamiPassHowToGetIt;
        break;

      case CredentialSubjectType.matterlightPass:
        image = ImageStrings.matterlightPassDummy;
        link = Urls.matterlightPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_matterlightPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_matterlightPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_matterlightPassHowToGetIt;
        break;

      case CredentialSubjectType.pigsPass:
        image = ImageStrings.pigsPassDummy;
        link = Urls.pigsPassCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_pigsPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_pigsPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_pigsPassHowToGetIt;
        break;

      case CredentialSubjectType.troopezPass:
        image = ImageStrings.trooperzPassDummy;
        link = Urls.trooperzPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_trooperzPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_trooperzPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_trooperzPassHowToGetIt;
        break;

      case CredentialSubjectType.tzlandPass:
        image = ImageStrings.tzlandPassDummy;
        link = Urls.tzlandPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tzlandPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tzlandPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_tzlandPassHowToGetIt;
        break;

      case CredentialSubjectType.tezoniaPass:
        image = ImageStrings.tezoniaPassDummy;
        link = Urls.tezoniaPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tezoniaPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tezoniaPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_tezoniaPassHowToGetIt;
        break;

      case CredentialSubjectType.phonePass:
        image = ImageStrings.dummyPhonePassCard;
        dummyDesc = ResponseString.RESPONSE_STRING_phoneProofDummyDescription;
        link = Urls.phonePassUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_phoneProofExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_phoneProofHowToGetIt;
        break;

      case CredentialSubjectType.bloometaPass:
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
      case CredentialSubjectType.loyaltyCard:
      case CredentialSubjectType.identityPass:
      case CredentialSubjectType.ecole42LearningAchievement:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.pcdsAgentCertificate:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
        break;
    }

    return HomeCredential(
      isDummy: true,
      image: image,
      link: link,
      credentialSubjectType: credentialSubjectType,
      whyGetThisCard:
          whyGetThisCard == null ? null : ResponseMessage(whyGetThisCard),
      expirationDateDetails: expirationDateDetails == null
          ? null
          : ResponseMessage(expirationDateDetails),
      howToGetIt: howToGetIt == null ? null : ResponseMessage(howToGetIt),
      websiteGameLink: websiteGameLink,
      dummyDescription: dummyDesc == null ? null : ResponseMessage(dummyDesc),
    );
  }

  final CredentialModel? credentialModel;
  final String? link;
  @JsonKey(ignore: true)
  final MessageHandler? dummyDescription;
  final String? image;
  final bool isDummy;
  final CredentialSubjectType credentialSubjectType;
  final String? websiteGameLink;
  @JsonKey(ignore: true)
  final MessageHandler? whyGetThisCard;
  @JsonKey(ignore: true)
  final MessageHandler? expirationDateDetails;
  @JsonKey(ignore: true)
  final MessageHandler? howToGetIt;

  Map<String, dynamic> toJson() => _$HomeCredentialToJson(this);

  @override
  List<Object?> get props => [
        credentialModel,
        link,
        image,
        isDummy,
        credentialSubjectType,
        websiteGameLink,
        whyGetThisCard,
        expirationDateDetails,
        howToGetIt,
        dummyDescription,
      ];
}
