import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      key: const Key('empty_state'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.plumTint,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.plumBorder),
              ),
              child: const Icon(
                Icons.search_off,
                size: 32,
                color: AppColors.plumLight,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No profiles match',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Try a different name or city.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              key: const Key('clear_search_button'),
              onPressed: onClear,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.plumLight,
                side: const BorderSide(color: AppColors.plumBorder),
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.field),
                ),
              ),
              child: const Text('Clear search'),
            ),
          ],
        ),
      ),
    );
  }
}