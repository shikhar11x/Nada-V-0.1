import 'package:flutter/material.dart';

import 'package:nada/app/theme/app_theme.dart';

/// Search box. The controller is owned by the screen, which also disposes it.
class ProfileSearchField extends StatelessWidget {
  const ProfileSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          key: const Key('search_field'),
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          autocorrect: false,
          style: Theme.of(context).textTheme.bodyLarge,
          cursorColor: AppColors.plumLight,
          decoration: InputDecoration(
            hintText: 'Search by name or city',
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: AppColors.muted,
            suffixIconColor: AppColors.muted,
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    key: const Key('search_clear'),
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close),
                    onPressed: onClear,
                  ),
          ),
        );
      },
    );
  }
}