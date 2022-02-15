import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';

abstract class ProfileEvent {}

class ProfileEventLoad extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {
  final ProfileModel model;

  ProfileEventUpdate(this.model);
}

abstract class ProfileState {}

class ProfileStateMessage extends ProfileState {
  final StateMessage message;

  ProfileStateMessage(this.message);
}

class ProfileStateDefault extends ProfileState {
  final ProfileModel model;

  ProfileStateDefault(this.model);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileStateDefault(ProfileModel())) {
        on<ProfileEventLoad>(_load);
        on<ProfileEventUpdate>(_update);
        add(ProfileEventLoad());
  }

  void _load(
    ProfileEventLoad event, Emitter<ProfileState> emit,
  ) async {
    final log = Logger('talao-wallet/profile/load');
    try {

      final firstName =
          await SecureStorageProvider.instance.get(ProfileModel.firstNameKey) ??
              '';
      final lastName =
          await SecureStorageProvider.instance.get(ProfileModel.lastNameKey) ??
              '';
      final phone =
          await SecureStorageProvider.instance.get(ProfileModel.phoneKey) ?? '';
      final location =
          await SecureStorageProvider.instance.get(ProfileModel.locationKey) ??
              '';
      final email =
          await SecureStorageProvider.instance.get(ProfileModel.emailKey) ?? '';
      final issuerVerificationSetting = !(await SecureStorageProvider.instance
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
    ProfileEventUpdate event, Emitter<ProfileState> emit,
  ) async {
    final log = Logger('talao-wallet/profile/update');

    try {

      await SecureStorageProvider.instance.set(
        ProfileModel.firstNameKey,
        event.model.firstName,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.lastNameKey,
        event.model.lastName,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.phoneKey,
        event.model.phone,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.locationKey,
        event.model.location,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.emailKey,
        event.model.email,
      );
      await SecureStorageProvider.instance.set(
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
