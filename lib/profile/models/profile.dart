import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    required this.email,
    required this.issuerVerificationSetting,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  static final empty = ProfileModel(
    firstName: '',
    lastName: '',
    phone: '',
    location: '',
    email: '',
    issuerVerificationSetting: true,
  );

  final String firstName;
  final String lastName;
  final String phone;
  final String location;
  final String email;
  final bool issuerVerificationSetting;

  @override
  List<Object> get props =>
      [firstName, lastName, phone, location, email, issuerVerificationSetting];

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith(
      {String? firstName,
      String? lastName,
      String? phone,
      String? location,
      String? email,
      bool? issuerVerificationSetting}) {
    return ProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      email: email ?? this.email,
      issuerVerificationSetting:
          issuerVerificationSetting ?? this.issuerVerificationSetting,
    );
  }
}
