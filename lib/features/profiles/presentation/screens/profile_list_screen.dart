import 'package:flutter/material.dart';

import 'package:nada/app/widgets/nada_wordmark.dart';
import 'package:nada/app/theme/app_theme.dart';

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NadaWordmark(),
              const SizedBox(height: AppSpacing.xl),
              Text('Discover connections', style: textTheme.displaySmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Marriage connections through the people your family already knows.',
                style: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}