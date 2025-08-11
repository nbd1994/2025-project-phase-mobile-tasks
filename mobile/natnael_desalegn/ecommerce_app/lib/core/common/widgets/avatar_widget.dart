import 'dart:math';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? name;
  final double radius;
  const AvatarWidget({
    super.key,
    this.name,
    this.radius = 20,
  });

  Color _bgColor() {
    final seed = name?.codeUnitAt(0) ?? Random().nextInt(26) + 65;
    final palette = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return palette[seed % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final letter =
        (name != null && name!.isNotEmpty) ? name![0].toUpperCase() : 'U';
    return CircleAvatar(
      radius: radius,
      backgroundColor: _bgColor(),
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}