class Encryption {
  Encryption({
    this.cipherText,
    this.authenticationTag,
  });

  String? cipherText;
  String? authenticationTag;

  factory Encryption.fromJson(Map<String, dynamic> json) => Encryption(
        cipherText: json['cipherText'],
        authenticationTag: json['authenticationTag'],
      );

  Map<String, dynamic> toJson() => {
        'cipherText': cipherText,
        'authenticationTag': authenticationTag,
      };
}
