import 'package:talao/app/shared/enum/revokation_status.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/display.dart';

void main() {
  group('CredentialModel', () {
    test('.toMap() encodes to map', () {
      final credential = CredentialModel(
        id: 'uuid',
        alias: null,
        image: 'image',
        data: {'issuer': 'did:...'},
        display: Display.emptyDisplay(),
        shareLink: '',
        credentialPreview: Credential.dummy(),
        revocationStatus: RevocationStatus.unknown,
      );
      final m = credential.toJson();

      expect(
          m,
          equals({
            'id': 'uuid',
            'alias': null,
            'image': 'image',
            'data': {'issuer': 'did:...'}
          }));
    });

    test('.fromMap() with only data field should generate an id', () {
      final m = {
        'data': {'issuer': 'did:...'}
      };
      final credential = CredentialModel.fromJson(m);
      expect(credential.id, isNotEmpty);
      expect(credential.data, equals(m['data']));
    });

    test('.fromMap() with id should not generate a new id', () {
      final m = {
        'id': 'uuid',
        'data': {'issuer': 'did:...'}
      };
      final credential = CredentialModel.fromJson(m);
      expect(credential.id, equals('uuid'));
    });
  });
}
