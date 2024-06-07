import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/utils/extensions.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import '../resources/resources.dart';

// Store last controller to be able to dismiss it
FlashController? _messageController;

/// Display a message to the user, like a SnackBar
Future<void> showMessage(BuildContext context, String message,
    {bool isError = false,
      String? details,
      int? durationInSeconds,
      Color? backgroundColor}) async {
  // Try to get higher level context, so the Flash message's position is relative to the phone screen (and not a child widget)
  final scaffoldContext = Scaffold.maybeOf(context)?.context;
  if (scaffoldContext != null) context = scaffoldContext;

  // Limit message length
  message = message.substringSafe(length: 200);

  // Dismiss previous message
  _messageController?.dismiss();

  // Display new message
  backgroundColor ??=
  (isError ? AppResources.colorVitamine : AppResources.colorVitamine);

  await showFlash(
    context: context,
    duration: Duration(seconds: durationInSeconds ?? (details == null ? 4 : 8)),
    builder: (context, controller) {
      _messageController = controller;

      return Flash(
        controller: controller,
        position: FlashPosition.top,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: FlashBar(
            controller: controller,
            dismissDirections: const [
              FlashDismissDirection.endToStart,
              FlashDismissDirection.startToEnd,
            ],
            behavior: FlashBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            position: FlashPosition.top,
            backgroundColor: backgroundColor,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: backgroundColor?.foregroundTextColor),
            ),
            primaryAction: details == null
                ? null
                : TextButton(
              child: Text(
                'Détails',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: Colors.white),
              ),
              onPressed: () {
                controller.dismiss();

                showDialog(
                  context: context,
                  // context and NOT parent context must be used, otherwise it may throw error

                  builder: (context) => AlertDialog(
                    title: SelectableText(message),
                    content: SelectableText(details),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );

  _messageController = null;
}
