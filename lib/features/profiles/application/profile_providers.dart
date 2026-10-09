import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/data/profile_repository.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return HttpProfileRepository(client: ref.watch(httpClientProvider));
});

/// Fetches once. The user's Retry button calls ref.invalidate(profilesProvider).
/// Riverpod 3 retries failed providers automatically; we turn that off so the
/// error state shows immediately and retry is always an explicit user action.
final profilesProvider = FutureProvider<List<Profile>>(
  (ref) => ref.watch(profileRepositoryProvider).fetchProfiles(),
  retry: (retryCount, error) => null,
);

/// What the user has typed in the search field.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;

  void clear() => state = '';
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Pure function, easy to unit test.
List<Profile> filterProfiles(List<Profile> profiles, String query) {
  return profiles.where((p) => p.matchesQuery(query)).toList();
}

/// Loaded profiles filtered by the query. Typing never refetches.
final filteredProfilesProvider = Provider<AsyncValue<List<Profile>>>((ref) {
  final query = ref.watch(searchQueryProvider);
  return ref
      .watch(profilesProvider)
      .whenData((profiles) => filterProfiles(profiles, query));
});