import 'package:dating_app/helpers/app_localizations.dart';
import 'package:dating_app/widgets/default_card_border.dart';
import 'package:flutter/material.dart';

/// Success Dialog
void successDialog(
  BuildContext context, {
  required String message,
  Widget? icon,
  String? title,
      bool isDismissable = true,
  String? negativeText,
  VoidCallback? negativeAction,
  String? positiveText,
  VoidCallback? positiveAction,
}) {
  _buildDialog(context, "success",
      message: message,
      isDismissable: isDismissable,
      icon: icon,
      title: title,
      negativeText: negativeText,
      negativeAction: negativeAction,
      positiveText: positiveText,
      positiveAction: positiveAction);
}

/// Error Dialog
void errorDialog(
  BuildContext context, {
      bool isDismissable = true,
  required String message,
  Widget? icon,
  String? title,
  String? negativeText,
  VoidCallback? negativeAction,
  String? positiveText,
  VoidCallback? positiveAction,
}) {
  _buildDialog(context, "error",
      message: message,
      isDismissable:isDismissable ,
      icon: icon,
      title: title,
      negativeText: negativeText,
      negativeAction: negativeAction,
      positiveText: positiveText,
      positiveAction: positiveAction);
}

/// Confirm Dialog
void confirmDialog(
  BuildContext context, {
      bool isDismissable = true,
  required String message,
  Widget? icon,
  String? title,
  String? negativeText,
  VoidCallback? negativeAction,
  String? positiveText,
  VoidCallback? positiveAction,
}) {
  _buildDialog(context, "confirm",
      isDismissable: isDismissable,
      icon: icon,
      title: title,
      message: message,
      negativeText: negativeText,
      negativeAction: negativeAction,
      positiveText: positiveText,
      positiveAction: positiveAction);
}

/// Confirm Dialog
void infoDialog(
  BuildContext context, {
      bool isDismissable = true,
  required String message,
  Widget? icon,
  String? title,
  String? negativeText,
  VoidCallback? negativeAction,
  String? positiveText,
  VoidCallback? positiveAction,
}) {
  _buildDialog(context, "info",
      icon: icon,
      isDismissable: isDismissable,
      title: title,
      message: message,
      negativeText: negativeText,
      negativeAction: negativeAction,
      positiveText: positiveText,
      positiveAction: positiveAction);
}

/// Build dialog
void _buildDialog(
  BuildContext context,
  String type, {
  required Widget? icon,
      bool isDismissable=true,
  required String? title,
  required String message,
  required String? negativeText,
  required VoidCallback? negativeAction,
  required String? positiveText,
  required VoidCallback? positiveAction,
}) {
  // Variables
  final i18n = AppLocalizations.of(context);
  final _textStyle =
      TextStyle(fontSize: 18, color: Theme.of(context).scaffoldBackgroundColor);
  late Widget _icon;
  late String _title;

  // Control type
  switch (type) {
    case "success":
      _icon = icon ??
          const CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.check, color: Colors.white),
          );
      _title = title ?? i18n.translate("success");
      break;
    case "error":
      _icon = icon ??
          const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.close, color: Colors.white),
          );
      _title = title ?? i18n.translate("error");
      break;
    case "confirm":
      _icon = icon ??
          const CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.help_outline, color: Colors.white),
          );
      _title = title ?? i18n.translate("are_you_sure");
      break;

    case "info":
      _icon = icon ??
          const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.info_outline, color: Colors.white),
          );
      _title = title ?? i18n.translate("information");
      break;
  }

  showDialog(
      context: context,
      barrierDismissible: isDismissable,
      builder: (context) {
        return AlertDialog(
          shape: defaultCardBorder(),
          title: Row(
            children: [
              _icon,
              const SizedBox(width: 10),
              Expanded(child: Text(_title, style: const TextStyle(fontSize: 22)))
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            /// Negative button
            negativeAction == null
                ? const SizedBox(width: 0, height: 0)
                : TextButton(
                    onPressed: negativeAction,
                    child: Text(negativeText ?? i18n.translate("CANCEL"),
                        style: const TextStyle(fontSize: 18, color: Colors.grey))),

            /// Positive button
            TextButton(
                onPressed: positiveAction ?? () => Navigator.of(context).pop(),
                child: Text(positiveText ?? i18n.translate("OK"),
                    style: _textStyle)),
          ],
        );
      });
}
