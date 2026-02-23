import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAvatarPicker extends StatelessWidget {
  final String fullName;
  final XFile? avatarFile;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onClear;

  const CreateAvatarPicker({
    super.key,
    required this.fullName,
    required this.avatarFile,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    ImageProvider? img;
    if (avatarFile != null) img = FileImage(File(avatarFile!.path));

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: scheme.primary.withOpacity(0.10),
          backgroundImage: img,
          child: img != null
              ? null
              : Text(
                  fullName.trim().isNotEmpty
                      ? fullName.trim()[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Avatar (optional)',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                avatarFile == null ? 'No file selected' : avatarFile!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        PopupMenuButton<String>(
          tooltip: 'Avatar options',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (v) {
            if (v == 'camera') onPickCamera();
            if (v == 'gallery') onPickGallery();
            if (v == 'clear') onClear();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'camera', child: Text('Camera')),
            const PopupMenuItem(value: 'gallery', child: Text('Gallery')),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'clear', child: Text('Remove')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.08)),
              color: scheme.surface,
            ),
            child: const Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
  }
}
