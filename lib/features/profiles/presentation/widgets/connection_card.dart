import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/widgets/degree_badge.dart';

/// The most prominent block on the details screen.
class ConnectionCard extends StatelessWidget {
  const ConnectionCard({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final connection = profile.connectedThrough;
    if (connection == null) {
      return _NoConnection(name: profile.name);
    }

    final textTheme = Theme.of(context).textTheme;
    final degree = profile.degree;

    return Semantics(
      container: true,
      label: 'Connected through: $connection',
      excludeSemantics: true,
      child: Container(
        key: const Key('connection_card'),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.plumTint,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.plumBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: AppColors.amber,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'CONNECTED THROUGH',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.plumLight,
                    ),
                  ),
                ),
                if (degree != null) DegreeBadge(degree: degree),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              connection,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoConnection extends StatelessWidget {
  const _NoConnection({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: 'No connection yet. No connection has been recorded for $name.',
      excludeSemantics: true,
      child: Container(
        key: const Key('no_connection_card'),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.cardRaised,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.link_off,
                size: 18,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No connection yet', style: textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'No connection has been recorded for $name yet.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}