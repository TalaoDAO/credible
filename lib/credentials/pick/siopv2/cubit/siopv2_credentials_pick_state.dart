part of 'query_by_example_credentials_pick_cubit.dart';

@JsonSerializable()
class SIOPV2CredentialPickState extends Equatable {
  SIOPV2CredentialPickState({this.index = 0});

  factory SIOPV2CredentialPickState.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2CredentialPickStateFromJson(json);

  final int index;

  SIOPV2CredentialPickState copyWith({int? index}) {
    return SIOPV2CredentialPickState(index: index ?? this.index);
  }

  Map<String, dynamic> toJson() => _$SIOPV2CredentialPickStateToJson(this);

  @override
  List<Object?> get props => [index];
}
