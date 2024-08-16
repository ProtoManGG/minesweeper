// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Bomb extends StatelessWidget {
  const Bomb({
    super.key,
    required this.revealed,
    required this.onTap,
  });
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: revealed ? Colors.grey[800] : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
