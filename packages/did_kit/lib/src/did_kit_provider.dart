class DIDKitProvider {
  String getVersion() {
    return 'stub';
  }

  String generateEd25519Key() {
    return '''{"kty":"OKP","crv":"Ed25519","x":"VW4M2_QGNxcplUzDMflsguYD-doia0FdKnmbQXdT4gU","d":"lwKFU-Ol4m_WM_V-3Fp_OIuN6VlOIxAr53Y9QCPP2R4"}''';
  }

  String keyToDID(String methodName, String key) {
    return 'did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56';
  }

  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return '''did:key:z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56#z6MkkCk2d3LN8qn6tWxR1qxibMCpp9E9vJVBrfv5djSk3F56''';
  }

  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return 'didKit stub';
  }

  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    return 'didKit stub';
  }

  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return 'didKit stub';
  }

  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return 'didKit stub';
  }

  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return 'didKit stub';
  }

  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return 'didKit stub';
  }

  Future<String> didAuth(
    String did,
    String options,
    String key,
  ) async {
    return 'didKit stub';
  }
}
