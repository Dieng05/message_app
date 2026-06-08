import 'package:flutter/material.dart';
import '../Config/SQLdb.dart';
import '../Config/SessionManager.dart';
import '../models/ContactModel.dart';
import '../models/MessageModel.dart';
import '../widgets/navigation.dart';
import '../widgets/message/contact_story_item.dart';
import '../widgets/message/conversation_tile.dart';
import '../widgets/message/message_search_bar.dart';
import '../pages/discussion.dart';

String _formatTime(String timestamp) {
  try {
    final dt = DateTime.parse(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(msgDay).inDays;

    if (diff == 0) return "${dt.hour.toString().padLeft(2, '0')}h${dt.minute.toString().padLeft(2, '0')}";
    if (diff == 1) return "Hier";
    if (diff < 7) {
      const days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
      return days[dt.weekday - 1];
    }
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
  } catch (_) {
    return timestamp;
  }
}

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final Sqldb _sqldb = Sqldb.instance;
  final TextEditingController _searchController = TextEditingController();

  String _currentUserId = '';
  List<ContactModel> _contacts = [];
  List<({ContactModel contact, Messagemodel lastMsg})> _conversations = [];
  List<({ContactModel contact, Messagemodel lastMsg})> _filtered = [];

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final email = await SessionManager.getCurrentUserEmail() ?? '';

    final contactRows = await _sqldb.readContacts(ownerEmail: email);
    final contacts = contactRows.map((r) => ContactModel(
      name: r['name'] as String,
      phone: r['phone'] as String,
    )).toList();

    final Map<String, ContactModel> phoneToContact = {
      for (final c in contacts) c.phone: c,
    };

    final msgRows = await _sqldb.readAllMessages(currentUserId: email);

    // Grouper par peer, garder le message le plus récent (déjà trié DESC)
    final Map<String, Messagemodel> lastMsgByPeer = {};
    for (final r in msgRows) {
      final idFrom = r['idFrom'].toString();
      final idTo   = r['idTo'].toString();
      final peerId = idFrom == email ? idTo : idFrom;
      if (!lastMsgByPeer.containsKey(peerId)) {
        lastMsgByPeer[peerId] = Messagemodel(idFrom, idTo, r['timestamp'].toString(), r['content'].toString(), r['type'] as int);
      }
    }

    final conversations = lastMsgByPeer.entries
        .map((e) {
          final contact = phoneToContact[e.key];
          if (contact == null) return null;
          return (contact: contact, lastMsg: e.value);
        })
        .whereType<({ContactModel contact, Messagemodel lastMsg})>()
        .toList()
      ..sort((a, b) => b.lastMsg.timestamp.compareTo(a.lastMsg.timestamp));

    if (mounted) {
      setState(() {
        _currentUserId = email;
        _contacts = contacts;
        _conversations = conversations;
        _filtered = conversations;
      });
    }
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _conversations
          : _conversations
              .where((c) => c.contact.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void _openDiscussion(BuildContext context, ContactModel contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Discussion(contact: contact, currentUserId: _currentUserId),
      ),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Conversations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            if (_contacts.isNotEmpty)
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) =>
                      ContactStoryItem(contact: _contacts[index]),
                ),
              ),

            const SizedBox(height: 12),

            MessageSearchBar(controller: _searchController),

            const SizedBox(height: 12),

            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text("Aucune conversation"))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final conv = _filtered[index];
                        return ConversationTile(
                          contact: conv.contact,
                          lastMsg: conv.lastMsg,
                          currentUserId: _currentUserId,
                          formattedTime: _formatTime(conv.lastMsg.timestamp),
                          onTap: () => _openDiscussion(context, conv.contact),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}