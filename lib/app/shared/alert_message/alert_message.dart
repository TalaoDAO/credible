import 'package:altme/app/app.dart';
import 'package:altme/app/shared/alert_message/extension.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  static void showStateMessage({
    required BuildContext context,
    required StateMessage stateMessage,
  }) {
    final MessageHandler messageHandler = stateMessage.messageHandler!;
    final String message = messageHandler.getMessage(context, messageHandler);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: stateMessage.type!.getColor(context),
      ),
    );
  }

  static void showStringMessage({
    required BuildContext context,
    required String message,
    MessageType messageType = MessageType.error,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: messageType.getColor(context),
      ),
    );
  }
}
