import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuctura_lms_app/src/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
