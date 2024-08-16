import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  const NumberBox({
    super.key,
    required this.child,
    required this.revealed,
    required this.onTap,
  });
  final String child;
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text(
              revealed
                  ? child == '0'
                      ? ''
                      : child
                  : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: child == '1'
                    ? Colors.blue
                    : child == '2'
                        ? Colors.green
                        : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
