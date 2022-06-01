class Constants {
  //TODO: Handle based on isEnterprise
  static final String defaultDIDMethod = 'tz';
  static final String defaultDIDMethodName = 'Tezos';
  static final String enterpriseDIDMethod = 'web';
  static final String enterpriseDIDMethodName = 'Web';
  static final String databaseFilename = 'wallet.db';
  static const String appContactWebsiteUrl = 'https://talao.io';
  static const String appContactWebsiteName = 'talao.io';
  static const String appContactMail = 'contact@talao.io';
  static const String checkIssuerTalaoUrl =
      'https://talao.co/trusted-issuers-registry/v1/issuers';
  static const String checkIssuerEbsiUrl =
      'https://api.conformance.intebsi.xyz/trusted-issuers-registry/v2/issuers';

  static const String ivVector = 'Talao';
  static const String additionalAuthenticatedData = 'Credible';
}
