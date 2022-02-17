import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/pages/profile/usecase/create_credential.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/app/shared/model/self_issued/self_issued.dart';

abstract class ProfileEvent {}

class ProfileEventLoad extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {
  final ProfileModel model;

  ProfileEventUpdate(this.model);
}

class ProfileDataEventSubmit extends ProfileEvent {
  final ProfileModel model;

  ProfileDataEventSubmit(this.model);
}

abstract class ProfileState {}

class ProfileStateMessage extends ProfileState {
  final StateMessage message;

  ProfileStateMessage(this.message);
}

class ProfileStateSubmitted extends ProfileState {
  final StateMessage message;

  ProfileStateSubmitted(this.message);
}

class ProfileStateDefault extends ProfileState {
  final ProfileModel model;

  ProfileStateDefault(this.model);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileStateDefault(ProfileModel())) {
    on<ProfileEventLoad>(_load);
    on<ProfileEventUpdate>(_update);
    on<ProfileDataEventSubmit>(_submit);
    add(ProfileEventLoad());
  }

  void _load(
    ProfileEventLoad event,
    Emitter<ProfileState> emit,
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

  void _submit(
    ProfileDataEventSubmit event,
    Emitter<ProfileState> emit,
  ) async {
    final log = Logger('talao-wallet/profile/submit');
    try {
      final firstName = event.model.firstName;
      final lastName = event.model.lastName;
      final phone = event.model.phone;
      final location = event.model.location;
      final email = event.model.email;

      final key = (await SecureStorageProvider.instance.get('key'))!;
      final did = DIDKitProvider.instance.keyToDID('key', key);
      final verificationMethod = DIDKitProvider.instance.keyToVerificationMethod('key', key);
      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': verificationMethod
      };

      final selfIssued = SelfIssued('', 'SelfIssued', location, lastName,
          firstName, phone, email, Author('', ''), did);

      final credential = selfIssued.toJson();

      final vc = await CreateCredential(
          credential: credential, options: options, key: key);

      emit(ProfileStateSubmitted(StateMessage.success(vc)));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ProfileStateMessage(
          StateMessage.error('Failed to submit profile data. '
              'Check the logs for more information.')));
    }
  }

  void _update(
    ProfileEventUpdate event,
    Emitter<ProfileState> emit,
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
