import 'package:flutter/material.dart';

void showDatabaseResetDialog(BuildContext context, String backupFilePath) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must acknowledge
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Database Reset"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Your application database was from a newer version and was incompatible with this app version."),
              Text("A new, empty database has been created."),
              const SizedBox(height: 10),
              Text("Your old database has been backed up to:"),
              SelectableText(backupFilePath, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("If you wish to use your old data, you must rename the backed-up file to 'syncopathyDB.sqlite' and use a compatible version of the application."),
              const SizedBox(height: 10),
              Text("Note: Renaming the backup will overwrite your new empty database."),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}
