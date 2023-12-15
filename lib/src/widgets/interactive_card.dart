import 'package:flutter/material.dart';
import 'package:studybuddy/src/utils/localization.dart';

class InteractiveCard extends StatelessWidget {
  final String label;
  final Widget destination;

  const InteractiveCard({
    Key? key,
    required this.label,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // For localized text

    return Padding(
      padding: const EdgeInsets.all(
          4.0), // Reduced padding for better space utilization
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  'assets/images/${label}_icon.png',
                  fit: BoxFit.contain, // Adjust image size within card
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  localizations?.translate(label) ?? 'Default Text',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold, // Adjust font size if necessary
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
