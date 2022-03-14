part of 'credentials_pick_cubit.dart';

@JsonSerializable()
class CredentialsPickState extends Equatable {
  CredentialsPickState({
    List<int>? selection,
  }) : selection = selection ?? <int>[];

  factory CredentialsPickState.fromJson(Map<String, dynamic> json) =>
      _$CredentialsPickStateFromJson(json);

  final List<int> selection;

  CredentialsPickState copyWith({List<int>? selection}) {
    return CredentialsPickState(selection: selection ?? this.selection);
  }

  Map<String, dynamic> toJson() => _$CredentialsPickStateToJson(this);

  @override
  List<Object?> get props => [selection];
}
