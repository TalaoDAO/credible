import 'package:bloc/bloc.dart';

class PersonalPageState {
  final bool isFirstName;
  final bool isLastName;
  final bool isPhone;
  final bool isLocation;
  final bool isEmail;
  final bool isCompanyName;
  final bool isCompanyWebsite;
  final bool isJobTitle;

  const PersonalPageState({
    this.isFirstName = true,
    this.isLastName = true,
    this.isPhone = true,
    this.isLocation = true,
    this.isEmail = true,
    this.isCompanyName = true,
    this.isCompanyWebsite = true,
    this.isJobTitle = true,
  });

  PersonalPageState copyWith({
    bool? isFirstName,
    bool? isLastName,
    bool? isPhone,
    bool? isLocation,
    bool? isEmail,
    bool? isCompanyName,
    bool? isCompanyWebsite,
    bool? isJobTitle,
  }) {
    return PersonalPageState(
      isFirstName: isFirstName ?? this.isFirstName,
      isLastName: isLastName ?? this.isLastName,
      isPhone: isPhone ?? this.isPhone,
      isLocation: isLocation ?? this.isLocation,
      isEmail: isEmail ?? this.isEmail,
      isCompanyName: isCompanyName ?? this.isCompanyName,
      isCompanyWebsite: isCompanyWebsite ?? this.isCompanyWebsite,
      isJobTitle: isJobTitle ?? this.isJobTitle,
    );
  }
}

class PersonalPgeCubit extends Cubit<PersonalPageState> {
  PersonalPgeCubit() : super(const PersonalPageState());

  void firstNameCheckBoxChange(bool? value) {
    emit(state.copyWith(isFirstName: value));
  }

  void lastNameCheckBoxChange(bool? value) {
    emit(state.copyWith(isLastName: value));
  }

  void phoneCheckBoxChange(bool? value) {
    emit(state.copyWith(isPhone: value));
  }

  void locationCheckBoxChange(bool? value) {
    emit(state.copyWith(isLocation: value));
  }

  void emailCheckBoxChange(bool? value) {
    emit(state.copyWith(isEmail: value));
  }

  void companyNameCheckBoxChange(bool? value) {
    emit(state.copyWith(isCompanyName: value));
  }

  void companyWebsiteCheckBoxChange(bool? value) {
    emit(state.copyWith(isCompanyWebsite: value));
  }

  void jobTitleCheckBoxChange(bool? value) {
    emit(state.copyWith(isJobTitle: value));
  }
}
