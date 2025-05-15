import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;

  const CustomActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 15), // valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
