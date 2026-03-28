import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';

class ImagePickerButton extends StatelessWidget {
  final ValueChanged<String> onImageSelected;
  final bool enabled;

  const ImagePickerButton({
    super.key,
    required this.onImageSelected,
    this.enabled = true,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        onImageSelected(picked.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Bild laden: $e'),
            backgroundColor: KaliColors.accentDanger,
          ),
        );
      }
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KaliColors.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KaliRadius.lg)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: KaliSpacing.paddingMD,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: KaliColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: KaliSpacing.md),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: KaliColors.accentPrimary),
                title: const Text('Kamera', style: TextStyle(color: KaliColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: KaliColors.accentPrimary),
                title: const Text('Galerie', style: TextStyle(color: KaliColors.textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              const SizedBox(height: KaliSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: enabled ? KaliColors.bgTertiary : KaliColors.borderColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: enabled ? () => _showPickerOptions(context) : null,
        icon: const Icon(
          Icons.image,
          color: KaliColors.textInverse,
          size: 20,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class ImagePreviewBubble extends StatelessWidget {
  final String imagePath;
  final bool isUser;

  const ImagePreviewBubble({
    super.key,
    required this.imagePath,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KaliSpacing.xxs),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: isUser ? KaliColors.bubbleUser : KaliColors.bubbleAi,
            borderRadius: isUser ? KaliRadius.bubbleUser : KaliRadius.bubbleAi,
            border: isUser
                ? null
                : Border.all(color: KaliColors.bubbleAiBorder, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 200,
              height: 150,
              color: KaliColors.bgTertiary,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: KaliColors.textMuted, size: 48),
                  SizedBox(height: 8),
                  Text('Bild konnte nicht geladen werden',
                      style: TextStyle(color: KaliColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
