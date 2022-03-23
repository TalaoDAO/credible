import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/qr_code/qr_code_scan/model/siopv2_param.dart';
import 'package:talao/scan/cubit/scan_cubit.dart';

part 'siopv2_credentials_pick_state.dart';

part 'siopv2_credentials_pick_cubit.g.dart';

class SIOPV2CredentialPickCubit extends Cubit<SIOPV2CredentialPickState> {
  final ScanCubit scanCubit;

  SIOPV2CredentialPickCubit({required this.scanCubit})
      : super(SIOPV2CredentialPickState());

  void toggle(int index) {
    if (state.index == index) return;
    emit(state.copyWith(index: index));
  }

  void presentCredentialToSIOPV2Request(
      {required CredentialModel credential,
      required SIOPV2Param sIOPV2Param}) async {
    emit(state.copyWith(loading: true));
    await scanCubit.presentCredentialToSiopV2Request(
        credential: credential, sIOPV2Param: sIOPV2Param);
    emit(state.copyWith(loading: false));
  }
}
