import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/profile_formatters.dart';
import 'package:nada/features/profiles/presentation/widgets/degree_badge.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_avatar.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profile, required this.onTap});

  final Profile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final age = profile.age;
    final subtitle = joinNonEmpty([profile.city, profile.profession]);

    return Semantics(
      button: true,
      label: profileSemanticsLabel(profile),
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: AppColors.card,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.plum.withValues(alpha: 0.2),
          highlightColor: AppColors.plum.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileAvatar(profile: profile),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  profile.name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleLarge,
                                ),
                              ),
                              if (age != null) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  '$age',
                                  style: textTheme.titleLarge?.copyWith(
                                    color: AppColors.muted,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Text(
                                    subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                _ConnectionSummary(profile: profile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionSummary extends StatelessWidget {
  const _ConnectionSummary({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final connection = profile.connectedThrough;
    final degree = profile.degree;

    if (connection == null) {
      return Row(
        children: [
          const Icon(Icons.link_off, size: 16, color: AppColors.muted),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text('No connection yet', style: textTheme.bodySmall),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 16,
              color: AppColors.plumLight,
            ),
            const SizedBox(width: AppSpacing.sm),
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
        const SizedBox(height: AppSpacing.sm),
        Text(
          connection,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}