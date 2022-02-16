part of 'did_bloc.dart';

abstract class DIDEvent {}

class DIDEventLoad extends DIDEvent {}

abstract class DIDState {}

class DIDStateWorking extends DIDState {}

class DIDStateMessage extends DIDState {
  final StateMessage message;

  DIDStateMessage(this.message);
}

class DIDStateDefault extends DIDState {
  final String DID;

  DIDStateDefault(this.DID);
}
