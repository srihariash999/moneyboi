import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profileImage;
  final double? radius;

  const ProfileAvatar({
    Key? key,
    this.profileImage,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.8),
      ),
      child: Container(
        height: radius ?? 35.0,
        width: radius ?? 35.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: profileImage == null
            ? const Icon(
                Icons.person,
                color: Colors.white,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 35.0),
                child: CachedNetworkImage(
                  imageUrl: profileImage!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
