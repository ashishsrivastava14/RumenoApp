import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search here...',
    this.onChanged,
    this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: RumenoTheme.textLight),
          prefixIcon: Icon(Icons.search, color: RumenoTheme.textGrey),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: Icon(Icons.tune, color: RumenoTheme.primaryGreen),
                  onPressed: onFilterTap,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
