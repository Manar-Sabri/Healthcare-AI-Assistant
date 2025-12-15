import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    super.key, 
    required this.title, 
    this.showBackButton = true
  });

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final shouldShowBack = showBackButton && canPop;

    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      
      // Left: Back Button
      leading: shouldShowBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
          
      // Right: Settings Button
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: AppTheme.primary),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const SettingsScreen())
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
