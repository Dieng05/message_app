import 'package:flutter/material.dart';
import '../../Config/SQLdb.dart';
import '../../Config/SessionManager.dart';
import '../../models/ContactModel.dart';
import '../../pages/discussion.dart';

class ListContact extends StatefulWidget {
  final String searchQuery;
  const ListContact({super.key, this.searchQuery = ''});

  @override
  State<ListContact> createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {
  final Sqldb _sqldb = Sqldb.instance;
  List<ContactModel> _contacts = [];
  String _currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final email = await SessionManager.getCurrentUserEmail() ?? '';
    final rows = await _sqldb.readContacts(ownerEmail: email);
    if (mounted) {
      setState(() {
        _currentUserEmail = email;
        _contacts = rows.map((r) => ContactModel(
          name: r['name'] as String,
          phone: r['phone'] as String,
        )).toList();
      });
    }
  }

  void _openDiscussion(BuildContext context, ContactModel contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Discussion(contact: contact, currentUserId: _currentUserEmail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.searchQuery.isEmpty
        ? _contacts
        : _contacts.where((c) =>
            c.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            c.phone.contains(widget.searchQuery)).toList();

    final Map<String, List<ContactModel>> grouped = {};
    for (final contact in filtered) {
      final letter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(contact);
    }
    final sortedKeys = grouped.keys.toList()..sort();

    if (filtered.isEmpty) {
      return const Center(child: Text("Aucun contact trouvé"));
    }

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