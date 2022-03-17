import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/message.dart';

part 'did_state.g.dart';

@JsonSerializable()
class DIDState extends Equatable {
  DIDState({
    this.did = '',
    this.didMethod = '',
    this.didMethodName = '',
    this.message,
  });

  factory DIDState.fromJson(Map<String, dynamic> json) =>
      _$DIDStateFromJson(json);

  final String? did;
  final String? didMethod;
  final String? didMethodName;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$DIDStateToJson(this);

  @override
  List<Object?> get props => [did, didMethod, didMethodName, message];
}

class DIDStateWorking extends DIDState {}

class DIDStateMessage extends DIDState {
  DIDStateMessage({StateMessage? message}) : super(message: message);
}

class DIDStateDefault extends DIDState {
  DIDStateDefault({String? did, String? didMethod, String? didMethodName})
      : super(did: did, didMethod: didMethod, didMethodName: didMethodName);
}
