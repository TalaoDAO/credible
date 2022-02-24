import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/drawer/profile/models/models.dart';

part 'profile_state.dart';

part 'profile_cubit.g.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SecureStorageProvider? secureStorageProvider;

  ProfileCubit({this.secureStorageProvider})
      : super(ProfileState(model: ProfileModel.empty)) {
    load();
  }

  void load() async {
    final log = Logger('talao-wallet/profile/load');
    try {
      final firstName =
          await secureStorageProvider!.get(Constants.firstNameKey) ?? '';
      final lastName =
          await secureStorageProvider!.get(Constants.lastNameKey) ?? '';
      final phone = await secureStorageProvider!.get(Constants.phoneKey) ?? '';
      final location =
          await secureStorageProvider!.get(Constants.locationKey) ?? '';
      final email = await secureStorageProvider!.get(Constants.emailKey) ?? '';
      final issuerVerificationSetting = !(await secureStorageProvider!
              .get(Constants.issuerVerificationSettingKey) ==
          'false');

      final model = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
        issuerVerificationSetting: issuerVerificationSetting,
      );

      emit(ProfileStateDefault(model: model));
    } catch (e) {
      log.severe('something went wrong', e);
      emit(ProfileStateMessage(
          message: StateMessage.error('Failed to load profile. '
              'Check the logs for more information.')));
    }
  }

  Future<void> update(ProfileModel profileModel) async {
    final log = Logger('talao-wallet/profile/update');

    try {
      await secureStorageProvider!.set(
        Constants.firstNameKey,
        profileModel.firstName,
      );
      await secureStorageProvider!.set(
        Constants.lastNameKey,
        profileModel.lastName,
      );
      await secureStorageProvider!.set(Constants.phoneKey, profileModel.phone);
      await secureStorageProvider!.set(
        Constants.locationKey,
        profileModel.location,
      );
      await secureStorageProvider!.set(
        Constants.emailKey,
        profileModel.email,
      );
      await secureStorageProvider!.set(
        Constants.issuerVerificationSettingKey,
        profileModel.issuerVerificationSetting.toString(),
      );

      emit(ProfileStateDefault(model: profileModel));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ProfileStateMessage(
          message: StateMessage.error('Failed to save profile. '
              'Check the logs for more information.')));
    }
  }
}
