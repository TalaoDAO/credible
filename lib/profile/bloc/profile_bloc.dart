import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';

part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SecureStorageProvider secureStorageProvider;

  ProfileBloc(this.secureStorageProvider)
      : super(ProfileStateDefault(ProfileModel())) {
    on<ProfileEventLoad>(_load);
    on<ProfileEventUpdate>(_update);
    add(ProfileEventLoad());
  }

  void _load(
    ProfileEventLoad event,
    Emitter<ProfileState> emit,
  ) async {
    final log = Logger('talao-wallet/profile/load');
    try {
      final firstName =
          await secureStorageProvider.get(ProfileModel.firstNameKey) ?? '';
      final lastName =
          await secureStorageProvider.get(ProfileModel.lastNameKey) ?? '';
      final phone =
          await secureStorageProvider.get(ProfileModel.phoneKey) ?? '';
      final location =
          await secureStorageProvider.get(ProfileModel.locationKey) ?? '';
      final email =
          await secureStorageProvider.get(ProfileModel.emailKey) ?? '';
      final issuerVerificationSetting = !(await secureStorageProvider
              .get(ProfileModel.issuerVerificationSettingKey) ==
          'false');

      final model = ProfileModel(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          location: location,
          email: email,
          issuerVerificationSetting: issuerVerificationSetting);

      emit(ProfileStateDefault(model));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ProfileStateMessage(StateMessage.error('Failed to load profile. '
          'Check the logs for more information.')));
    }
  }

  void _update(
    ProfileEventUpdate event,
    Emitter<ProfileState> emit,
  ) async {
    final log = Logger('talao-wallet/profile/update');

    try {
      await secureStorageProvider.set(
        ProfileModel.firstNameKey,
        event.model.firstName,
      );
      await secureStorageProvider.set(
        ProfileModel.lastNameKey,
        event.model.lastName,
      );
      await secureStorageProvider.set(ProfileModel.phoneKey, event.model.phone);
      await secureStorageProvider.set(
        ProfileModel.locationKey,
        event.model.location,
      );
      await secureStorageProvider.set(
        ProfileModel.emailKey,
        event.model.email,
      );
      await secureStorageProvider.set(
        ProfileModel.issuerVerificationSettingKey,
        event.model.issuerVerificationSetting.toString(),
      );

      emit(ProfileStateDefault(event.model));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ProfileStateMessage(StateMessage.error('Failed to save profile. '
          'Check the logs for more information.')));
    }
  }
}
