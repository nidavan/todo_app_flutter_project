import 'package:flutter/material.dart';

class CustomDeleteConfirmDialog {
  /// Shows the delete confirmation dialog.
  static Future<void> show({
    required BuildContext context,
    String title = 'Delete',
    String message = 'Are you sure you want to delete this item?',
    required Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(title, textAlign: TextAlign.center)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
