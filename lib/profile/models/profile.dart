class ProfileModel {
  static const String firstNameKey = 'profile/firstName';
  final String firstName;

  static const String lastNameKey = 'profile/lastName';
  final String lastName;

  static const String phoneKey = 'profile/phone';
  final String phone;

  static const String locationKey = 'profile/location';
  final String location;

  static const String emailKey = 'profile/email';
  final String email;

  static const String issuerVerificationSettingKey =
      'profile/issuerVerificationSetting';
  final bool issuerVerificationSetting;

  const ProfileModel({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.location = '',
    this.email = '',
    this.issuerVerificationSetting = true,
  });
}
