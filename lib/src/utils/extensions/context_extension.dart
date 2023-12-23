import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get mounted {
    return findRenderObject() != null;
  }
}
