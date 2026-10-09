import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_avatar.dart';

/// Placeholder. Replaced by the real details screen in Phase 4.
class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileAvatar(profile: profile, size: 96),
              const SizedBox(height: AppSpacing.md),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}