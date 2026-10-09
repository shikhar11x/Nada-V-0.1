import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/app/widgets/nada_wordmark.dart';
import 'package:nada/core/app_exception.dart';
import 'package:nada/features/profiles/application/profile_providers.dart';

class ProfileListScreen extends ConsumerWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final profiles = ref.watch(profilesProvider);

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
              const SizedBox(height: AppSpacing.lg),
              profiles.when(
                skipLoadingOnRefresh: false,
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e is AppException ? e.message : 'Something went wrong.'),
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton(
                      onPressed: () => ref.invalidate(profilesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
                data: (list) => Text('Loaded ${list.length} profiles'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}