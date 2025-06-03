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
    final file = File(imageLink);

    print("ImageLink ${imageLink}");
    print("File ${file}");

    final bool isNetwork = imageLink.startsWith('http');
    final bool isLocalFile = !isNetwork && file.existsSync();
    
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: isNetwork
            ? Image.network(
                imageLink,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/placeholder.png',
                  fit: BoxFit.cover,
                ),
              )
            : isLocalFile
                ? Image.file(
                    file,
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
