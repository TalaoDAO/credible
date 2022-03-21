import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'siopv2_credentials_pick_state.dart';

part 'siopv2_credentials_pick_cubit.g.dart';

class SIOPV2CredentialPickCubit extends Cubit<SIOPV2CredentialPickState> {
  SIOPV2CredentialPickCubit() : super(SIOPV2CredentialPickState());

  void toggle(int index) {
    emit(state.copyWith(index: index));
  }
}
