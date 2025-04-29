import 'package:flutter/material.dart';

class ImageSourcePicker extends StatelessWidget {
  const ImageSourcePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.camera_alt_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Camera'),
          onTap: () => Navigator.pop(context, 'camera'),
        ),
        ListTile(
          leading: Icon(
            Icons.photo_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Gallery'),
          onTap: () => Navigator.pop(context, 'gallery'),
        ),
      ],
    );
  }
}
