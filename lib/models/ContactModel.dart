import 'dart:ui';

class ContactModel {
  final String name;
  final String phone;
  final String email; // identifiant Firestore (colonne userId en SQLite)

  const ContactModel({
    required this.name,
    this.phone = '',
    this.email = '',
  });

  String get initial {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Color get color {
    final colors = [
      const Color(0xFFD97706),
      const Color(0xFFF97316),
      const Color(0xFF22C55E),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
      const Color(0xFFE11D48),
      const Color(0xFF0EA5E9),
      const Color(0xFF84CC16),
      const Color(0xFFF59E0B),
    ];

    final index = name.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }
}