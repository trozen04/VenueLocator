import 'package:flutter/material.dart';
import '../Utils/colors.dart';
import '../Utils/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.brandNewBorder,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Text(title, style: AppTextStyles.appBarTitle),
      centerTitle: true,
      actions: actions,
    );
  }
}
