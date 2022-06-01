import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credential_manifest/helpers/get_text_from_credential.dart';
import 'package:talao/query_by_example/model/credential_query.dart';

part 'query_by_example_credentials_pick_state.dart';

part 'query_by_example_credentials_pick_cubit.g.dart';

class QueryByExampleCredentialPickCubit
    extends Cubit<QueryByExampleCredentialPickState> {
  QueryByExampleCredentialPickCubit({
    List<CredentialModel> credentialList = const <CredentialModel>[],
    required CredentialQuery credentialQuery,
  }) : super(QueryByExampleCredentialPickState(filteredCredentialList: [])) {
    final filteredCredentialList = List<CredentialModel>.from(credentialList);

    /// filter credential list if there are type restrictions
    if (credentialQuery.example?.type != null) {
      filteredCredentialList.removeWhere((credential) {
        /// A credential must satisfy each field to be candidate for presentation
        var isPresentationCandidate = false;
        final searchList = getTextsFromCredential(r'$.type', credential.data);
        if (searchList.isNotEmpty) {
          /// I remove credential not
          searchList.removeWhere((element) =>
              element == credentialQuery.example?.type ? false : true);

          /// if [searchList] is not empty we mark this credential as a valid candidate
          if (searchList.isNotEmpty) {
            isPresentationCandidate = true;
          }
        }

        /// Remove non candidate credential from the list
        return !isPresentationCandidate;
      });
    }

    /// filter credential list if there are issuer restrictions
    var issuerList = credentialQuery.example?.trustedIssuer;
    if (issuerList != null) {
      for (final issuer in issuerList) {
        filteredCredentialList.removeWhere((credential) {
          /// A credential must satisfy each field to be candidate for presentation
          var isPresentationCandidate = false;
          final searchList =
              getTextsFromCredential(r'$.issuer', credential.data);
          if (searchList.isNotEmpty) {
            /// I remove element not matching requested issuer
            searchList.removeWhere(
                (element) => element == issuer.issuer ? false : true);

            /// if [searchList] is not empty we mark this credential as a valid candidate
            if (searchList.isNotEmpty) {
              isPresentationCandidate = true;
            }
          }

          /// Remove non candidate credential from the list
          return !isPresentationCandidate;
        });
      }
    }

    emit(QueryByExampleCredentialPickState(
      filteredCredentialList: filteredCredentialList,
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
