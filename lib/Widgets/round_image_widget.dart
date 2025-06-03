import 'dart:io';
import 'package:flutter/material.dart';

class RoundImageWidget extends StatelessWidget {
  final String imageLink;
  final double size;

  const RoundImageWidget({
    super.key,
    required this.imageLink,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: imageLink.startsWith('http')
            ? Image.network(
                imageLink,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/placeholder.png',
                  fit: BoxFit.cover,
                ),
              )
            : File(imageLink).existsSync()
                ? Image.file(
                    File(imageLink),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/placeholder.png',
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }
}
