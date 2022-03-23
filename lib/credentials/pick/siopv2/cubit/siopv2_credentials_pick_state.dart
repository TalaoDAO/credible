part of 'siopv2_credentials_pick_cubit.dart';

@JsonSerializable()
class SIOPV2CredentialPickState extends Equatable {
  SIOPV2CredentialPickState({this.index = 0, this.loading = false});

  factory SIOPV2CredentialPickState.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2CredentialPickStateFromJson(json);

  final int index;
  final bool loading;

  SIOPV2CredentialPickState copyWith({int? index, bool? loading}) {
    return SIOPV2CredentialPickState(
        index: index ?? this.index, loading: loading ?? this.loading);
  }

  Map<String, dynamic> toJson() => _$SIOPV2CredentialPickStateToJson(this);

  @override
  List<Object?> get props => [index, loading];
}
