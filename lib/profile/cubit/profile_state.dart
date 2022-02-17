part of 'profile_cubit.dart';

@JsonSerializable()
class ProfileState extends Equatable {
  ProfileState({this.stateMessage, this.profileModel});

  // factory ProfileState.fromJson(Map<String, dynamic> json) =>
  //     _$ProfileStateFromJson(json);

  final ProfileModel? profileModel;
  final StateMessage? stateMessage;

  //Map<String, dynamic> toJson() => _$ProfileStateToJson(this);

  @override
  List<Object?> get props => [profileModel, stateMessage];
}

class ProfileStateMessage extends ProfileState {
  final StateMessage? message;

  ProfileStateMessage({this.message});
}

class ProfileStateDefault extends ProfileState {
  final ProfileModel? model;

  ProfileStateDefault({this.model});
}
