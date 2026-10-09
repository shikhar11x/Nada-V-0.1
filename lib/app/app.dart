import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';
import 'package:nada/features/profiles/presentation/screens/profile_list_screen.dart';

class NadaApp extends StatelessWidget {
  const NadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NADA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const ProfileListScreen(),
    );
  }
}