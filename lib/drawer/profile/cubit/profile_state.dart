part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({this.message, this.model});

  // factory ProfileState.fromJson(Map<String, dynamic> json) =>
  //     _$ProfileStateFromJson(json);

  final ProfileModel? model;
  final StateMessage? message;

  //Map<String, dynamic> toJson() => _$ProfileStateToJson(this);

  @override
  List<Object?> get props => [model, message];
}

class ProfileStateMessage extends ProfileState {
  ProfileStateMessage({StateMessage? message}) : super(message: message);
}

class ProfileStateDefault extends ProfileState {
  ProfileStateDefault({ProfileModel? model}) : super(model: model);
}
