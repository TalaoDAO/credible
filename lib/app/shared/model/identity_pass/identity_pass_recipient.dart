import 'package:json_annotation/json_annotation.dart';

part 'identity_pass_recipient.g.dart';

@JsonSerializable()
class IdentityPassRecipient {
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String telephone;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String birthDate;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String gender;
  @JsonKey(defaultValue: '')
  final String jobTitle;

  factory IdentityPassRecipient.fromJson(Map<String, dynamic> json) =>
      _$IdentityPassRecipientFromJson(json);

  IdentityPassRecipient(this.email, this.image, this.telephone, this.familyName,
      this.address, this.birthDate, this.givenName, this.gender, this.jobTitle);

  Map<String, dynamic> toJson() => _$IdentityPassRecipientToJson(this);
}
