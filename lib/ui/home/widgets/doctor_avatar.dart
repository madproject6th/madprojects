import 'package:flutter/material.dart';

class DoctorAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const DoctorAvatar({super.key, required this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.blue.withValues(alpha: 0.12),
              alignment: Alignment.center,
              child: Icon(
                Icons.person_rounded,
                color: Colors.blue,
                size: radius,
              ),
            );
          },
        ),
      ),
    );
  }
}

