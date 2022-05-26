import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credential_manifest/helpers/get_filtered_credential_list.dart';

part 'credential_manifest_pick_state.dart';

part 'credential_manifest_pick_cubit.g.dart';

/// This Cubit provide list of Credentials as required by issuer
class CredentialManifestPickCubit extends Cubit<CredentialManifestPickState> {
  CredentialManifestPickCubit({
    List<CredentialModel> credentialList = const <CredentialModel>[],
    Map<String, dynamic> presentationDefinition = const {},
  }) : super(CredentialManifestPickState(filteredCredentialList: [])) {
    /// Get instruction to filter credentials of the wallet
    getFilteredCredentialList(presentationDefinition, credentialList);
    emit(CredentialManifestPickState(
      filteredCredentialList: credentialList,
    ));
  }

  void toggle(int index) {
    final selection;
    if (state.selection.contains(index)) {
      selection = List.of(state.selection)
        ..removeWhere((element) => element == index);
    } else {
      selection = List.of(state.selection)..add(index);
    }
    emit(state.copyWith(
        selection: selection,
        filteredCredentialList: state.filteredCredentialList));
  }
}
