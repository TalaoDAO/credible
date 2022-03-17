import 'package:file_picker/file_picker.dart';

class SubmitEnterpriseUserState {
  final PlatformFile? rsaFile;
  final String did;

  const SubmitEnterpriseUserState({this.rsaFile, this.did = ''});

  SubmitEnterpriseUserState copyWith({PlatformFile? rsaFile, String? did}) {
    return SubmitEnterpriseUserState(
        rsaFile: rsaFile ?? this.rsaFile, did: did ?? this.did);
  }
}