import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/scan/cubit/scan_message_string_state.dart';

part 'message.g.dart';

enum MessageType {
  error,
  warning,
  info,
  success,
}

@JsonSerializable()
class StateMessage extends Equatable {
  StateMessage(
      {this.serverMessage, this.message, this.type, this.errorHandler});

  factory StateMessage.fromJson(Map<String, dynamic> json) =>
      _$StateMessageFromJson(json);

  @JsonKey(name: 'message')
  final String? serverMessage;
  @JsonKey(ignore: true)
  final ScanMessageStringState? message;
  final MessageType? type;
  @JsonKey(ignore: true)
  final ErrorHandler? errorHandler;

  StateMessage.error({this.serverMessage,this.message, this.errorHandler})
      : type = MessageType.error;

  StateMessage.warning({this.serverMessage,this.message, this.errorHandler})
      : type = MessageType.warning;

  StateMessage.info({this.serverMessage,this.message, this.errorHandler})
      : type = MessageType.info;

  StateMessage.success({this.serverMessage,this.message, this.errorHandler})
      : type = MessageType.success;

  Map<String, dynamic> toJson() => _$StateMessageToJson(this);

  @override
  List<Object?> get props => [message, serverMessage, type];

  Color? get color {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.yellow;
      case MessageType.info:
        return Colors.cyan;
      case MessageType.success:
        return Colors.green;
      default:
        Colors.green;
    }
    return null;
  }

  String? getMessage(BuildContext context) {
    return message?.getMessage(context) ?? serverMessage;
  }
}
