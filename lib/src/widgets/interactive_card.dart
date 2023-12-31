import 'package:flutter/material.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:go_router/go_router.dart';

/// A widget that creates an interactive card for use in a Flutter application.
///
/// This card typically represents a feature or action in the application. When tapped,
/// it navigates to a specified destination. It displays an image and a label, which can be localized.
class InteractiveCard extends StatelessWidget {
  /// The label text displayed on the card. Used for both display and to fetch the corresponding image.
  final String label;

  /// The navigation destination path when the card is tapped.
  final String destination;

  /// Creates an InteractiveCard widget.
  ///
  /// [label] is a string used to display text on the card and to determine the image asset to use.
  /// [destination] is a string that defines the navigation route to be followed when the card is tapped.
  const InteractiveCard({
    super.key,
    required this.label,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch localized text based on the current application context.
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () => context.push(destination),
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  'assets/images/${label}_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  localizations?.translate(label) ?? 'Default Text',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
