import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fuctura_lms_app/l10n/app_localizations.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking Fuctura')),
      body: const Center(child: Text('Ranking Geral')),
    );
  }
}
