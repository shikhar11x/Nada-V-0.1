import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/data/profile.dart';
import 'package:nada/features/profiles/presentation/profile_formatters.dart';

/// Initials avatar. The colour is picked from the profile id, so the same
/// person always gets the same colour. No photos are invented.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, this.size = 52});

  final Profile profile;
  final double size;

  static const List<({Color bg, Color fg})> _palettes = [
    (bg: Color(0xFF3A1F37), fg: Color(0xFFE9C4E3)),
    (bg: Color(0xFF2E2440), fg: Color(0xFFCDBBF0)),
    (bg: Color(0xFF40222E), fg: Color(0xFFF0BFCB)),
    (bg: Color(0xFF2A2A44), fg: Color(0xFFBFC6F2)),
    (bg: Color(0xFF3B2B22), fg: Color(0xFFEBCDB0)),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _palettes[profile.id.abs() % _palettes.length];
    return Hero(
      tag: 'profile-avatar-${profile.id}',
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.bg,
            borderRadius: BorderRadius.circular(size * 0.3),
            border: Border.all(color: palette.fg.withValues(alpha: 0.25)),
          ),
          child: Text(
            initialsOf(profile.name),
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontFamily: AppTheme.serifFamily,
              fontSize: size * 0.36,
              fontWeight: FontWeight.w700,
              height: 1,
              color: palette.fg,
            ),
          ),
        ),
      ),
    );
  }
}