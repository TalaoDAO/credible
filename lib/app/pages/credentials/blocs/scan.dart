import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

abstract class ScanEvent {}

class ScanEventShowPreview extends ScanEvent {
  final Map<String, dynamic> preview;

  ScanEventShowPreview(this.preview);
}

class ScanEventCredentialOffer extends ScanEvent {
  final String url;
  final CredentialModel credentialModel;
  final String key;

  ScanEventCredentialOffer(
    this.url,
    this.credentialModel,
    this.key,
  );
}

class ScanEventVerifiablePresentationRequest extends ScanEvent {
  final String url;
  final String key;
  final List<CredentialModel> credentials;
  final String? challenge;
  final String? domain;

  ScanEventVerifiablePresentationRequest({
    required this.url,
    required this.key,
    required this.credentials,
    this.challenge,
    this.domain,
  });
}

class ScanEventCHAPIStore extends ScanEvent {
  final Map<String, dynamic> data;
  final void Function(String) done;

  ScanEventCHAPIStore(
    this.data,
    this.done,
  );
}

class ScanEventCHAPIGetDIDAuth extends ScanEvent {
  final String keyId;
  final String? challenge;
  final String? domain;
  final Uri uri;
  final void Function(String) done;

  ScanEventCHAPIGetDIDAuth(
    this.keyId,
    this.done,
    this.uri, {
    this.challenge,
    this.domain,
  });
}

class ScanEventCHAPIAskPermissionDIDAuth extends ScanEvent {
  final String keyId;
  final String? challenge;
  final String? domain;
  final Uri uri;
  final void Function(String) done;

  ScanEventCHAPIAskPermissionDIDAuth(
    this.keyId,
    this.done,
    this.uri, {
    this.challenge,
    this.domain,
  });
}

class ScanEventCHAPIGetQueryByExample extends ScanEvent {
  final String keyId;
  final List<CredentialModel> credentials;
  final String? challenge;
  final String? domain;
  final void Function(String) done;
  final Uri uri;

  ScanEventCHAPIGetQueryByExample(
    this.keyId,
    this.credentials,
    this.uri,
    this.done, {
    this.challenge,
    this.domain,
  });
}

class ScanEventCHAPIStoreQueryByExample extends ScanEvent {
  final Map<String, dynamic> data;
  final Uri uri;

  ScanEventCHAPIStoreQueryByExample(
    this.data,
    this.uri,
  );
}

abstract class ScanState {
  Uri? get uri => null;
}

class ScanStateIdle extends ScanState {}

class ScanStateWorking extends ScanState {}

class ScanStateMessage extends ScanState {
  final StateMessage message;

  ScanStateMessage(this.message);
}

class ScanStatePreview extends ScanState {
  final Map<String, dynamic> preview;

  ScanStatePreview({
    required this.preview,
  });
}

class ScanStateSuccess extends ScanState {}

class ScanStateCHAPIStoreQueryByExample extends ScanState {
  final Map<String, dynamic> data;
  @override
  final Uri uri;
  ScanStateCHAPIStoreQueryByExample(
    this.data,
    this.uri,
  );
}

class ScanStateCHAPIAskPermissionDIDAuth extends ScanState {
  final String keyId;
  final String? challenge;
  final String? domain;
  @override
  final Uri uri;
  final void Function(String) done;

  ScanStateCHAPIAskPermissionDIDAuth(
    this.keyId,
    this.done,
    this.uri, {
    this.challenge,
    this.domain,
  });
}

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final Dio client;
  final WalletBloc walletBloc;

  ScanBloc(this.client, this.walletBloc) : super(ScanStateIdle());

  @override
  Stream<ScanState> mapEventToState(ScanEvent event) async* {
    if (event is ScanEventShowPreview) {
      yield ScanStatePreview(preview: event.preview);
    } else if (event is ScanEventCredentialOffer) {
      yield* _credentialOffer(event);
    } else if (event is ScanEventVerifiablePresentationRequest) {
      yield* _verifiablePresentationRequest(event);
    } else if (event is ScanEventCHAPIStore) {
      yield* _CHAPIStore(event);
    } else if (event is ScanEventCHAPIGetDIDAuth) {
      yield* _CHAPIGetDIDAuth(event);
    } else if (event is ScanEventCHAPIGetQueryByExample) {
      yield* _CHAPIGetQueryByExample(event);
    } else if (event is ScanEventCHAPIStoreQueryByExample) {
      yield* _CHAPIStoreQueryByExample(event);
    } else if (event is ScanEventCHAPIAskPermissionDIDAuth) {
      yield* _CHAPIAskPermissionDIDAuth(event);
    }
  }

  Stream<ScanState> _credentialOffer(
    ScanEventCredentialOffer event,
  ) async* {
    final log = Logger('credible/scan/credential-offer');

    yield ScanStateWorking();

    final url = event.url;
    final credentialModel = event.credentialModel;
    final keyId = event.key;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);

      final credential = await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'subject_id': did}),
      );

      final jsonCredential = credential.data is String
          ? jsonDecode(credential.data)
          : credential.data;

      final vcStr = jsonEncode(jsonCredential);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      final verification =
          await DIDKitProvider.instance.verifyCredential(vcStr, optStr);

      print('[credible/credential-offer/verify/vc] $vcStr');
      print('[credible/credential-offer/verify/options] $optStr');
      print('[credible/credential-offer/verify/result] $verification');

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);

        yield ScanStateMessage(StateMessage.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.'));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);

        yield ScanStateMessage(
            StateMessage.error('Failed to verify credential. '
                'Check the logs for more information.'));
      }

      await walletBloc.insertCredential(CredentialModel.copyWithData(
          oldCredentialModel: credentialModel, newData: jsonCredential));

      yield ScanStateMessage(StateMessage.success(
          'A new credential has been successfully added!'));

      yield ScanStateSuccess();
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    yield ScanStateIdle();
  }

  Stream<ScanState> _verifiablePresentationRequest(
    ScanEventVerifiablePresentationRequest event,
  ) async* {
    final log = Logger('credible/scan/verifiable-presentation-request');
    yield ScanStateWorking();

    final url = event.url;
    final keyId = event.key;
    final challenge = event.challenge;
    final domain = event.domain;
    final credentials = event.credentials;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await DIDKitProvider.instance
          .keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await DIDKitProvider.instance.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentials.length == 1
              ? credentials.first.data
              : credentials.map((c) => c.data).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      await client.post(
        url.toString(),
        data: FormData.fromMap(<String, dynamic>{
          'presentation': presentation,
        }),
      );

      yield ScanStateMessage(
          StateMessage.success('Successfully presented your credential!'));

      yield ScanStateSuccess();
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    yield ScanStateIdle();
  }

  Stream<ScanState> _CHAPIStore(
    ScanEventCHAPIStore event,
  ) async* {
    final log = Logger('credible/scan/chapi-store');

    yield ScanStateWorking();

    final data = event.data;
    final done = event.done;

    try {
      late final type;

      if (data['type'] is List<dynamic>) {
        type = data['type'].first;
      } else {
        type = data['type'];
      }

      late final vc;

      switch (type) {
        case 'VerifiablePresentation':
          vc = data['verifiableCredential'];
          break;

        case 'VerifiableCredential':
          vc = data;
          break;

        default:
          throw UnimplementedError('Unsupported dataType: $type');
      }

      final vcStr = jsonEncode(vc);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      final verification =
          await DIDKitProvider.instance.verifyCredential(vcStr, optStr);

      print('[credible/chapi-store/verify/vc] $vcStr');
      print('[credible/chapi-store/verify/options] $optStr');
      print('[credible/chapi-store/verify/result] $verification');

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);

        yield ScanStateMessage(StateMessage.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.'));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);

        // done(jsonEncode(jsonVerification['errors']));

        yield ScanStateMessage(
            StateMessage.error('Failed to verify credential. '
                'Check the logs for more information.'));
      }
await walletBloc.insertCredential(vc);

      done(vcStr);

      yield ScanStateMessage(StateMessage.success(
          'A new credential has been successfully added!'));
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    yield ScanStateSuccess();

    yield ScanStateIdle();
  }

  Stream<ScanState> _CHAPIGetDIDAuth(
    ScanEventCHAPIGetDIDAuth event,
  ) async* {
    final log = Logger('credible/scan/chapi-get-didauth');
    yield ScanStateWorking();

    final keyId = event.keyId;
    final challenge = event.challenge;
    final domain = event.domain;
    final done = event.done;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await DIDKitProvider.instance
          .keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentation = await DIDKitProvider.instance.DIDAuth(
        did,
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );
      final credential = await client.post(
        event.uri.toString(),
        data: FormData.fromMap(<String, dynamic>{
          'presentation': presentation,
        }),
      );
      if (credential.data == 'ok') {
        done(presentation);

        yield ScanStateMessage(
            StateMessage.success('Successfully presented your DID!'));

        yield ScanStateSuccess();
      } else {
        yield ScanStateMessage(StateMessage.error(
            'Something went wrong, please try again later.'));
      }
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '));
    }

    yield ScanStateSuccess();

    yield ScanStateIdle();
  }

  Stream<ScanState> _CHAPIGetQueryByExample(
    ScanEventCHAPIGetQueryByExample event,
  ) async* {
    final log = Logger('credible/scan/chapi-get-querybyexample');
    yield ScanStateWorking();

    final keyId = event.keyId;
    final challenge = event.challenge;
    final domain = event.domain;
    final credentials = event.credentials;
    final done = event.done;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await DIDKitProvider.instance
          .keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await DIDKitProvider.instance.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentials.length == 1
              ? credentials.first.toJson()
              : credentials.map((c) => c.toJson()).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      done(presentation);

      yield ScanStateMessage(
          StateMessage.success('Successfully presented your credential(s)!'));
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    yield ScanStateSuccess();

    yield ScanStateIdle();
  }

  Stream<ScanState> _CHAPIStoreQueryByExample(
      ScanEventCHAPIStoreQueryByExample event) async* {
    yield ScanStateCHAPIStoreQueryByExample(event.data, event.uri);
  }

  Stream<ScanState> _CHAPIAskPermissionDIDAuth(
      ScanEventCHAPIAskPermissionDIDAuth event) async* {
    yield ScanStateCHAPIAskPermissionDIDAuth(event.keyId, event.done, event.uri,
        challenge: event.challenge, domain: event.domain);
  }
}
