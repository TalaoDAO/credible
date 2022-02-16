part of 'didkit_bloc.dart';

abstract class DIDKitEvent {}

class DIDKitEventLoad extends DIDKitEvent {}

abstract class DIDKitState {}

class DIDKitStateWorking extends DIDKitState {}

class DIDKitStateMessage extends DIDKitState {
  final StateMessage message;

  DIDKitStateMessage(this.message);
}

class DIDKitStateDefault extends DIDKitState {
  final String DIDKit;

  DIDKitStateDefault(this.DIDKit);
}
