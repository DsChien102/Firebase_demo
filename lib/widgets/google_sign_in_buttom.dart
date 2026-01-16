import 'package:flutter/material.dart';

class GoogleSignInBottom extends StatelessWidget {
  final void Function()? onTap;
  const GoogleSignInBottom({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.tertiary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Image.asset('lib/assets/google.png', height: 32)],
        ),
      ),
    );
  }
}
