import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String initials;
  final Color borderColor;
  final Color textColor;
  final double size;

  const Avatar({
    super.key,
    required this.initials,
    required this.borderColor,
    required this.textColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AvatarRow extends StatelessWidget {
  const AvatarRow({super.key});

  static const _avatars = [
    (initials: 'SD', color: Color(0xFF3B82F6), label: 'Moi'),
    (initials: 'LE', color: Color(0xFFD97706), label: 'Lena'),
    (initials: 'SA', color: Color(0xFFF97316), label: 'Safia'),
    (initials: 'JE', color: Color(0xFF22C55E), label: 'Jean'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: _avatars
          .map(
            (a) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Avatar(
              initials: a.initials,
              borderColor: a.color,
              textColor: a.color,
            ),
            const SizedBox(height: 6),
            Text(
              a.label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}