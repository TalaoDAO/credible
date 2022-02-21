import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/pages/profile/usecase/create_credential.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:uuid/uuid.dart';

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
      final verificationMethod =
          await DIDKitProvider.instance.keyToVerificationMethod('key', key);
      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': verificationMethod
      };
      final verifyOptions = {'proofPurpose': 'assertionMethod'};

      final id = 'urn:uuid:' + Uuid().v4();
      ;
      final selfIssuedJson = {
        '@context': [
          'https://www.w3.org/2018/credentials/v1',
          {
            'name': 'https://schema.org/name',
            'description': 'https://schema.org/description',
            'SelfIssued': {
              '@context': {
                '@protected': true,
                '@version': 1.1,
                'address': 'schema:address',
                'email': 'schema:email',
                'familyName': 'schema:familyName',
                'givenName': 'scheama:givenName',
                'id': '@id',
                'schema': 'https://schema.org/',
                'telephone': 'schema:telephone',
                'type': '@type'
              },
              '@id': 'https://github.com/TalaoDAO/context/blob/main/README.md'
            }
          }
        ],
        'id': id,
        'type': ['VerifiableCredential', 'SelfIssued'],
        'credentialSubject': {
          'id': did,
          'type': 'SelfIssued',
          'address': location,
          'email': email,
          'familyName': lastName,
          'givenName': firstName,
          'telephone': phone,
        },
        'issuer': did,
        'issuanceDate': '2022-02-12T09:14:58Z',
        'description': [
          {
            '@language': 'en',
            '@value':
                'This signed electronic certificate has been issued by the user itself.'
          },
          {'@language': 'de', '@value': ''},
          {
            '@language': 'fr',
            '@value':
                "Cette attestation électronique est signée par l'utilisateur."
          }
        ],
        'name': [
          {'@language': 'en', '@value': 'Self Issued credential'},
          {'@language': 'de', '@value': ''},
          {'@language': 'fr', '@value': 'Attestation déclarative'}
        ]
      };

      final verifyResult = await CreateCredential(
          credential: selfIssuedJson,
          options: options,
          verifyOptions: verifyOptions,
          key: key);

      emit(ProfileStateSubmitted(StateMessage.success('success')));
    } catch (e, s) {
      print('e: $e,s: $s');
      log.severe('something went wrong', e, s);

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
