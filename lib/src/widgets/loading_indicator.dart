import 'package:flutter/material.dart';

/// A widget for displaying a loading indicator in a Flutter application.
///
/// Presents a centralized circular progress indicator, optionally accompanied by a message.
class LoadingIndicator extends StatelessWidget {
  /// The optional message to display below the loading indicator.
  /// If provided, it is displayed; otherwise, only the indicator is shown.
  final String? message;

  /// Creates a LoadingIndicator widget.
  ///
  /// [message] is an optional parameter. If provided, it is displayed below the progress indicator.
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          // Displays the message if it is not null.
          if (message != null) Text(message!),
        ],
      ),
    );
  }
}
