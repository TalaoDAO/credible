import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';

class SubmitEnterpriseUserState {
  final PlatformFile? rsaFile;

  SubmitEnterpriseUserState({this.rsaFile});
}

class SubmitEnterpriseUserCubit extends Cubit<SubmitEnterpriseUserState> {
  SubmitEnterpriseUserCubit() : super(SubmitEnterpriseUserState());

  void setRSAFile(PlatformFile? rsaFile) {
    emit(SubmitEnterpriseUserState(rsaFile: rsaFile));
  }
}
