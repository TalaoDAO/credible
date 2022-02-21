import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageType {
  error,
  warning,
  info,
  success,
}

@JsonSerializable()
class StateMessage extends Equatable {
  StateMessage({this.message, this.type});

  factory StateMessage.fromJson(Map<String, dynamic> json) =>
      _$StateMessageFromJson(json);

  final String? message;
  final MessageType? type;

  StateMessage.error(this.message)
      : type = MessageType.error;

  StateMessage.warning(this.message)
      : type = MessageType.warning;

  StateMessage.info(this.message)
      : type = MessageType.info;

  StateMessage.success(this.message)
      : type = MessageType.success;

  Map<String, dynamic> toJson() => _$StateMessageToJson(this);

  @override
  List<Object?> get props => [message, type];

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
}
