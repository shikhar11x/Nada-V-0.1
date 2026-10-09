import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:nada/core/app_exception.dart';
import 'package:nada/features/profiles/data/profile_repository.dart';

HttpProfileRepository _repoReturning(
  String body, {
  int status = 200,
  Duration timeout = const Duration(seconds: 5),
}) {
  final client = MockClient(
    (_) async => http.Response.bytes(
      utf8.encode(body),
      status,
      // The real file is served as plain text, so mimic that.
      headers: {'content-type': 'text/plain; charset=utf-8'},
    ),
  );
  return HttpProfileRepository(client: client, timeout: timeout);
}

void main() {
  test('decodes a plain-text JSON body into profiles', () async {
    final repo = _repoReturning(
      jsonEncode({
        'profiles': [
          {'id': 1, 'name': 'Ananya Sharma', 'city': 'Noida'},
          {'id': 2, 'name': 'Rohan Agarwal', 'city': 'Delhi'},
        ],
      }),
    );

    final profiles = await repo.fetchProfiles();

    expect(profiles, hasLength(2));
    expect(profiles.first.name, 'Ananya Sharma');
  });

  test('keeps Hindi text intact', () async {
    final repo = _repoReturning(
      jsonEncode({
        'profiles': [
          {
            'id': 16,
            'name': 'Aditya Tiwari',
            'connected_through': 'आपके मौसा जी के बैंक के सहकर्मी।',
          },
        ],
      }),
    );

    final profiles = await repo.fetchProfiles();

    expect(profiles.single.connectedThrough, 'आपके मौसा जी के बैंक के सहकर्मी।');
  });

  test('skips a malformed entry but keeps the valid ones', () async {
    final repo = _repoReturning(
      jsonEncode({
        'profiles': [
          {'id': 1, 'name': 'Valid Person'},
          {'id': 2, 'name': null},
          'not an object',
        ],
      }),
    );

    final profiles = await repo.fetchProfiles();

    expect(profiles.map((p) => p.name), ['Valid Person']);
  });

  test('a non-200 status becomes an AppException', () async {
    final repo = _repoReturning('Server error', status: 500);

    expect(repo.fetchProfiles(), throwsA(isA<AppException>()));
  });

  test('a network failure becomes an AppException', () async {
    final repo = HttpProfileRepository(
      client: MockClient((_) async => throw http.ClientException('offline')),
    );

    expect(repo.fetchProfiles(), throwsA(isA<AppException>()));
  });

  test('a timeout becomes an AppException', () async {
    final never = Completer<http.Response>();
    final repo = HttpProfileRepository(
      client: MockClient((_) => never.future),
      timeout: const Duration(milliseconds: 20),
    );

    expect(repo.fetchProfiles(), throwsA(isA<AppException>()));
  });

  test('invalid JSON becomes an AppException', () async {
    final repo = _repoReturning('this is not json');

    expect(repo.fetchProfiles(), throwsA(isA<AppException>()));
  });

  test('JSON without a profiles array becomes an AppException', () async {
    final repo = _repoReturning(jsonEncode({'people': []}));

    expect(repo.fetchProfiles(), throwsA(isA<AppException>()));
  });
}