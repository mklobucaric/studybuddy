import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  LoadingIndicator({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16),
          if (message != null) Text(message!),
        ],
      ),
    );
  }
}
