class Encryption {
  Encryption({
    this.cipherText,
    this.authenticationTag,
    this.date,
  });

  String? cipherText;
  String? authenticationTag;
  String? date;

  factory Encryption.fromJson(Map<String, dynamic> json) => Encryption(
        cipherText: json['cipherText'],
        authenticationTag: json['authenticationTag'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'cipherText': cipherText,
        'authenticationTag': authenticationTag,
        'date': date,
      };
}
