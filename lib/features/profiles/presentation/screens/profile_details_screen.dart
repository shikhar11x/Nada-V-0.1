import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/profile_formatters.dart';
import 'package:nada/features/profiles/presentation/widgets/connection_card.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_avatar.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final fields = profileFields(profile);
    final about = profile.about;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                AppSpacing.sm,
                20,
                AppSpacing.xl,
              ),
              children: [
                _Header(profile: profile),
                const SizedBox(height: AppSpacing.lg),
                ConnectionCard(profile: profile),
                if (fields.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _FieldsCard(fields: fields),
                ],
                if (about != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _AboutCard(text: about),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final age = profile.age;
    final summary = joinNonEmpty([
      age == null ? null : '$age years',
      profile.city,
    ]);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileAvatar(profile: profile, size: 84),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.name, style: textTheme.headlineSmall),
              if (summary != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  summary,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldsCard extends StatelessWidget {
  const _FieldsCard({required this.fields});

  final List<ProfileField> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('fields_card'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) const Divider(),
            _FieldRow(field: fields[i]),
          ],
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.field});

  final ProfileField field;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: '${field.label}: ${field.value}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label.toUpperCase(), style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(field.value, style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      key: const Key('about_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ABOUT', style: textTheme.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(text, style: textTheme.bodyLarge?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}