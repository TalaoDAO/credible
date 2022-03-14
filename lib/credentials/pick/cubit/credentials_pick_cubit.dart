import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credentials_pick_state.dart';

part 'credentials_pick_cubit.g.dart';

class CredentialsPickCubit extends Cubit<CredentialsPickState> {
  CredentialsPickCubit() : super(CredentialsPickState());

  void toggle(int index) {
    final selection;
    if (state.selection.contains(index)) {
      selection = List.of(state.selection)
        ..removeWhere((element) => element == index);
    } else {
      selection = List.of(state.selection)..add(index);
    }
    emit(state.copyWith(selection: selection));
  }
}
