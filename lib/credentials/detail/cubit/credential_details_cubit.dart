import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/shared/enum/verification_status.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

part 'credential_details_state.dart';

part 'credential_details_cubit.g.dart';

class CredentialDetailsCubit extends Cubit<CredentialDetailsState> {
  final WalletCubit walletCubit;
  final DIDKitProvider didKitProvider;

  CredentialDetailsCubit(
      {required this.walletCubit, required this.didKitProvider})
      : super(CredentialDetailsState());

  void setTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void verify(CredentialModel item) async {
    final vcStr = jsonEncode(item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final result =
        await DIDKitProvider.instance.verifyCredential(vcStr, optStr);
    final jsonResult = jsonDecode(result);

    if (jsonResult['warnings'].isNotEmpty) {
      emit(state.copyWith(
          verificationState: VerificationState.VerifiedWithWarning));
    } else if (jsonResult['errors'].isNotEmpty) {
      if (jsonResult['errors'][0] == 'No applicable proof') {
        emit(state.copyWith(verificationState: VerificationState.Unverified));
      } else {
        emit(state.copyWith(
            verificationState: VerificationState.VerifiedWithError));
      }
    } else {
      emit(state.copyWith(verificationState: VerificationState.Verified));
    }
  }

  void update(CredentialModel item, String newAlias) async {
    final newCredential = CredentialModel.copyWithAlias(
      oldCredentialModel: item,
      newAlias: newAlias,
    );
    await walletCubit.updateCredential(newCredential);
    setTitle(newAlias);
  }
}
