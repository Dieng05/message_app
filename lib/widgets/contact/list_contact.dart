import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/ContactModel.dart';
import '../../pages/discussion.dart';
import '../../services/ContactService.dart';

class ListContact extends StatelessWidget {
  final String searchQuery;
  const ListContact({super.key, this.searchQuery = ''});

  void _openDiscussion(BuildContext context, ContactModel contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Discussion(contact: contact)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownerEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return StreamBuilder<List<ContactModel>>(
      stream: ContactService.instance.contactsStream(ownerEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final all = snapshot.data ?? [];
        final filtered = searchQuery.isEmpty
            ? all
            : all
                .where((c) =>
                    c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    c.email.contains(searchQuery))
                .toList();

        if (filtered.isEmpty) {
          return const Center(child: Text("Aucun contact trouvé"));
        }

        final Map<String, List<ContactModel>> grouped = {};
        for (final c in filtered) {
          grouped.putIfAbsent(c.name[0].toUpperCase(), () => []).add(c);
        }
        final sortedKeys = grouped.keys.toList()..sort();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: sortedKeys.length,
          itemBuilder: (context, i) {
            final letter = sortedKeys[i];
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
                        contact.email,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.message_outlined),
                        color: Colors.grey[500],
                        onPressed: () => _openDiscussion(context, contact),
                      ),
                      onTap: () => _openDiscussion(context, contact),
                    )),
                const Divider(height: 1, indent: 8),
              ],
            );
          },
        );
      },
    );
  }
}