import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'submit_enterprise_user_state.dart';

class SubmitEnterpriseUserCubit extends Cubit<SubmitEnterpriseUserState> {
  SubmitEnterpriseUserCubit() : super(SubmitEnterpriseUserState());

  void setRSAFile(PlatformFile? rsaFile) {
    emit(state.copyWith(rsaFile: rsaFile));
  }
}
