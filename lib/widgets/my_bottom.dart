import 'package:flutter/material.dart';

class MyButtom extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButtom({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Center(
          child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
