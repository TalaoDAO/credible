import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/drawer/profile/models/models.dart';

part 'profile_cubit.g.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SecureStorageProvider secureStorageProvider;

  ProfileCubit({required this.secureStorageProvider})
      : super(ProfileState(model: ProfileModel.empty)) {
    load();
  }

  void load() async {
    final log = Logger('talao-wallet/profile/load');
    try {
      final firstName =
          await secureStorageProvider.get(Constants.firstNameKey) ?? '';
      final lastName =
          await secureStorageProvider.get(Constants.lastNameKey) ?? '';
      final phone = await secureStorageProvider.get(Constants.phoneKey) ?? '';
      final location =
          await secureStorageProvider.get(Constants.locationKey) ?? '';
      final email = await secureStorageProvider.get(Constants.emailKey) ?? '';
      final companyName =
          await secureStorageProvider.get(SecureStorageKeys.companyName) ?? '';
      final companyWebsite =
          await secureStorageProvider.get(SecureStorageKeys.companyWebsite) ??
              '';
      final jobTitle =
          await secureStorageProvider.get(SecureStorageKeys.jobTitle) ?? '';
      final issuerVerificationSetting = !(await secureStorageProvider
              .get(Constants.issuerVerificationSettingKey) ==
          'false');

      final model = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
        issuerVerificationSetting: issuerVerificationSetting,
        companyName: companyName,
        companyWebsite: companyWebsite,
        jobTitle: jobTitle,
      );

      final isEnterprise =
          await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);

      emit(ProfileStateDefault(
          model: model, isEnterprise: isEnterprise == 'true'));
    } catch (e) {
      log.severe('something went wrong', e);
      emit(ProfileStateMessage(
          message: StateMessage.error('Failed to load profile. '
              'Check the logs for more information.')));
    }
  }

  Future<void> resetProfile() async {
    await secureStorageProvider.delete(Constants.firstNameKey);
    await secureStorageProvider.delete(Constants.lastNameKey);
    await secureStorageProvider.delete(Constants.phoneKey);
    await secureStorageProvider.delete(Constants.locationKey);
    await secureStorageProvider.delete(Constants.emailKey);
    await secureStorageProvider.delete(SecureStorageKeys.jobTitle);
    await secureStorageProvider.delete(SecureStorageKeys.companyWebsite);
    await secureStorageProvider.delete(SecureStorageKeys.companyName);
    final isEnterprise =
        await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);
    emit(ProfileStateDefault(
        model: ProfileModel.empty, isEnterprise: isEnterprise == 'true'));
  }

  Future<void> update(ProfileModel profileModel) async {
    final log = Logger('talao-wallet/profile/update');

    try {
      await secureStorageProvider.set(
        Constants.firstNameKey,
        profileModel.firstName,
      );
      await secureStorageProvider.set(
        Constants.lastNameKey,
        profileModel.lastName,
      );
      await secureStorageProvider.set(Constants.phoneKey, profileModel.phone);
      await secureStorageProvider.set(
        Constants.locationKey,
        profileModel.location,
      );
      await secureStorageProvider.set(
        Constants.emailKey,
        profileModel.email,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.companyName,
        profileModel.companyName.toString(),
      );
      await secureStorageProvider.set(
        SecureStorageKeys.companyWebsite,
        profileModel.companyWebsite.toString(),
      );
      await secureStorageProvider.set(
        SecureStorageKeys.jobTitle,
        profileModel.jobTitle.toString(),
      );
      await secureStorageProvider.set(
        Constants.issuerVerificationSettingKey,
        profileModel.issuerVerificationSetting.toString(),
      );

      final isEnterprise =
          await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);

      emit(ProfileStateDefault(
          model: profileModel, isEnterprise: isEnterprise == 'true'));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ProfileStateMessage(
          message: StateMessage.error('Failed to save profile. '
              'Check the logs for more information.')));
    }
  }
}
