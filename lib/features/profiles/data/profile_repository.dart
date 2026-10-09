import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:nada/core/app_config.dart';
import 'package:nada/core/app_exception.dart';
import 'package:nada/features/profiles/data/profile.dart';

abstract class ProfileRepository {
  Future<List<Profile>> fetchProfiles();
}

class HttpProfileRepository implements ProfileRepository {
  HttpProfileRepository({
    required this.client,
    Uri? url,
    this.timeout = const Duration(seconds: 15),
  }) : _url = url ?? Uri.parse(AppConfig.profilesUrl);

  final http.Client client;
  final Uri _url;
  final Duration timeout;

  @override
  Future<List<Profile>> fetchProfiles() async {
    final http.Response response;
    try {
      response = await client.get(_url).timeout(timeout);
    } on TimeoutException catch (e) {
      throw AppException(
        'The request timed out. Please check your connection and try again.',
        cause: e,
      );
    } on Exception catch (e) {
      throw AppException(
        "Couldn't reach the server. Please check your connection and try again.",
        cause: e,
      );
    }

    if (response.statusCode != 200) {
      throw AppException(
        'The server responded with an error (${response.statusCode}). Please try again.',
      );
    }

    // The file is served as plain text, so we decode the JSON ourselves.
    // Decoding bodyBytes as UTF-8 keeps Hindi text intact regardless of
    // the charset header.
    final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException catch (e) {
      throw AppException(
        'The profile data was not in the expected format.',
        cause: e,
      );
    }

    if (decoded is! Map<String, dynamic> || decoded['profiles'] is! List) {
      throw const AppException(
        'The profile data was not in the expected format.',
      );
    }

    final profiles = <Profile>[];
    for (final item in decoded['profiles'] as List) {
      try {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Profile entry is not an object.');
        }
        profiles.add(Profile.fromJson(item));
      } on FormatException catch (e) {
        // One bad entry should not hide the other profiles, but it is logged.
        debugPrint('Skipping malformed profile: ${e.message}');
      }
    }
    return profiles;
  }
}