import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/app/widgets/nada_wordmark.dart';
import 'package:nada/core/app_exception.dart';
import 'package:nada/features/profiles/application/profile_providers.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/profile_formatters.dart';
import 'package:nada/features/profiles/presentation/screens/profile_details_screen.dart';
import 'package:nada/features/profiles/presentation/widgets/empty_state_view.dart';
import 'package:nada/features/profiles/presentation/widgets/error_state_view.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_card.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_list_skeleton.dart';
import 'package:nada/features/profiles/presentation/widgets/profile_search_field.dart';

const double _horizontalPadding = 20;

class ProfileListScreen extends ConsumerStatefulWidget {
  const ProfileListScreen({super.key});

  @override
  ConsumerState<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends ConsumerState<ProfileListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    ref.read(searchQueryProvider.notifier).setQuery(value);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  void _retry() => ref.invalidate(profilesProvider);

  void _openProfile(Profile profile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileDetailsScreen(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(filteredProfilesProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            profiles.when(
              skipLoadingOnRefresh: false,
              loading: () => const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  AppSpacing.sm,
                  _horizontalPadding,
                  AppSpacing.lg,
                ),
                sliver: SliverToBoxAdapter(child: ProfileListSkeleton()),
              ),
              error: (error, _) {
                if (error is! AppException) {
                  debugPrint('Unexpected error loading profiles: $error');
                }
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorStateView(
                    message: error is AppException
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    onRetry: _retry,
                  ),
                );
              },
              data: _buildData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _horizontalPadding,
        AppSpacing.md,
        _horizontalPadding,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NadaWordmark(),
          const SizedBox(height: AppSpacing.lg),
          Text('Discover', style: textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Marriage connections through the people your family already knows.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileSearchField(
            controller: _searchController,
            onChanged: _onQueryChanged,
            onClear: _clearSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildData(List<Profile> list) {
    if (list.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(onClear: _clearSearch),
      );
    }

    final query = ref.watch(searchQueryProvider);
    final total = ref.watch(profilesProvider).value?.length ?? list.length;
    final label = resultsLabel(shown: list.length, total: total, query: query);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        _horizontalPadding,
        AppSpacing.sm,
        _horizontalPadding,
        AppSpacing.lg,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final profile = list[index];
              return ProfileCard(
                key: ValueKey('profile_card_${profile.id}'),
                profile: profile,
                onTap: () => _openProfile(profile),
              );
            },
          ),
        ],
      ),
    );
  }
}