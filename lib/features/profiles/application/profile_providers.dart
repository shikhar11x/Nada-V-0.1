import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

import 'package:nada/features/profiles/data/profile_repository.dart';
import 'package:nada/features/profiles/data/profile.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return HttpProfileRepository(client: ref.watch(httpClientProvider));
});

/// Fetches once. Retry = ref.invalidate(profilesProvider).
final profilesProvider = FutureProvider<List<Profile>>((ref) {
  return ref.watch(profileRepositoryProvider).fetchProfiles();
});

/// What the user has typed in the search field.
final searchQueryProvider = StateProvider<String>((ref) => '');

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