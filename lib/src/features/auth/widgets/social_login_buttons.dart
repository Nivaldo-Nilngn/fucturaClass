import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuctura_lms_app/l10n/app_localizations.dart';
import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';
import 'package:fuctura_lms_app/src/core/theme/app_theme.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                l10n.loginOrContinueWith,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
            Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 18),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.github, size: 18),
                label: const Text('GitHub'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.githubButtonColor,
                  foregroundColor: AppTheme.githubButtonText,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
