import 'package:flutter/material.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';

enum MessageType {
  error,
  warning,
  info,
  success,
}

class StateMessage {

  final String message;
  final MessageType type;
  final ErrorHandler? errorHandler;

  StateMessage.error(this.message, {this.errorHandler})
      : type = MessageType.error;

  StateMessage.warning(this.message, {this.errorHandler})
      : type = MessageType.warning;

  StateMessage.info(this.message, {this.errorHandler})
      : type = MessageType.info;

  StateMessage.success(this.message, {this.errorHandler})
      : type = MessageType.success;

  Color get color {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.yellow;
      case MessageType.info:
        return Colors.cyan;
      case MessageType.success:
        return Colors.green;
    }
  }
}
