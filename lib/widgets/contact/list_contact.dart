import 'package:flutter/material.dart';
import '../../models/ContactModel.dart';
import '../../pages/discussion.dart';

class ListContact extends StatefulWidget {
  const ListContact({super.key});

  @override
  State<ListContact> createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {
  final List<ContactModel> _contacts = const [
    ContactModel(name: 'Lena Martin',  phone: '+33 6 12 34 56 78'),
    ContactModel(name: 'Safia Benali', phone: '+33 6 98 76 54 32'),
    ContactModel(name: 'Jean Dupont',  phone: '+33 6 55 44 33 22'),
    ContactModel(name: 'Marie Curie',  phone: '+33 6 11 22 33 44'),
    ContactModel(name: 'Paul Bernard', phone: '+33 6 77 88 99 00'),
    ContactModel(name: 'Alice Morel',  phone: '+33 6 33 44 55 66'),
    ContactModel(name: 'Lucas Petit',  phone: '+33 6 22 11 00 99'),
    ContactModel(name: 'Emma Leroy',   phone: '+33 6 44 55 66 77'),
  ];

  void _openDiscussion(BuildContext context, ContactModel contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Discussion(contact: contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<ContactModel>> grouped = {};
    for (final contact in _contacts) {
      final letter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(contact);
    }
    final sortedKeys = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: sortedKeys.length,
      itemBuilder: (context, sectionIndex) {
        final letter = sortedKeys[sectionIndex];
        final contacts = grouped[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.red[300],
                ),
              ),
            ),
            ...contacts.map((contact) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: CircleAvatar(
                backgroundColor: contact.color.withOpacity(0.25),
                child: Text(
                  contact.initial,
                  style: TextStyle(
                    color: contact.color,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                contact.phone,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.message_outlined),
                    color: Colors.grey[500],
                    onPressed: () => _openDiscussion(context, contact),
                  ),
                ],
              ),
              onTap: () => _openDiscussion(context, contact),
            )),
            const Divider(height: 1, indent: 8),
          ],
        );
      },
    );
  }
}