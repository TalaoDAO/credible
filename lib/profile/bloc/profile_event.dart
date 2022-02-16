part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventLoad extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {
  final ProfileModel model;

  ProfileEventUpdate(this.model);
}

abstract class ProfileState {}

class ProfileStateMessage extends ProfileState {
  final StateMessage message;

  ProfileStateMessage(this.message);
}

class ProfileStateDefault extends ProfileState {
  final ProfileModel model;

  ProfileStateDefault(this.model);
}
