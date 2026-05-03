import 'package:flutter/material.dart';
import '../models/ContactModel.dart';
import '../models/MessageModel.dart';
import '../widgets/navigation.dart';
import '../widgets/message/contact_story_item.dart';
import '../widgets/message/conversation_tile.dart';
import '../widgets/message/message_search_bar.dart';
import '../pages/discussion.dart';

final List<ContactModel> _contacts = [
  const ContactModel(name: "Siaka Dosso", phone: "0601020304"),
  const ContactModel(name: "Lena Dupont", phone: "0602030405"),
  const ContactModel(name: "Safia Amara", phone: "0603040506"),
  const ContactModel(name: "Jean Martin", phone: "0604050607"),
];

const Map<String, int> _contactIndexById = {
  "user_0": 0,
  "user_1": 1,
  "user_2": 2,
  "user_3": 3,
};

const String _currentUserId = "me";

final List<Messagemodel> _allMessages = [
  Messagemodel("user_0", _currentUserId, "2025-05-02 10:45", "Tes disponible ce soir ?", 0),
  Messagemodel(_currentUserId, "user_0", "2025-05-02 10:30", "Ouais dis moi", 0),
  Messagemodel("user_1", _currentUserId, "2025-05-02 09:30", "On se voit demain ?", 0),
  Messagemodel(_currentUserId, "user_1", "2025-05-02 09:00", "Avec plaisir !", 0),
  Messagemodel("user_2", _currentUserId, "2025-05-02 08:15", "Merci pour tout !", 0),
  Messagemodel(_currentUserId, "user_3", "2025-05-01 18:00", "C'est bon pour moi", 0),
  Messagemodel("user_3", _currentUserId, "2025-05-01 17:45", "T'es dispo lundi ?", 0),
];


String _peerId(Messagemodel msg) =>
    msg.idFrom == _currentUserId ? msg.idTo : msg.idFrom;

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

List<Messagemodel> _messagesForPeer(String peerId) {
  return _allMessages.where((m) => _peerId(m) == peerId).toList();
}

String? _peerIdForContact(ContactModel contact) {
  final entry = _contactIndexById.entries.where(
        (e) => _contacts[e.value] == contact,
  );
  return entry.isEmpty ? null : entry.first.key;
}

List<({ContactModel contact, Messagemodel lastMsg})> _buildConversations() {
  final Map<String, List<Messagemodel>> byPeer = {};
  for (final msg in _allMessages) {
    final peer = _peerId(msg);
    byPeer.putIfAbsent(peer, () => []).add(msg);
  }

  final conversations = byPeer.entries.map((entry) {
    final peer = entry.key;
    final msgs = entry.value
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final contactIndex = _contactIndexById[peer];
    if (contactIndex == null) return null;
    return (contact: _contacts[contactIndex], lastMsg: msgs.first);
  }).whereType<({ContactModel contact, Messagemodel lastMsg})>().toList();

  conversations.sort((a, b) => b.lastMsg.timestamp.compareTo(a.lastMsg.timestamp));
  return conversations;
}


class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final TextEditingController _searchController = TextEditingController();
  late List<({ContactModel contact, Messagemodel lastMsg})> _conversations;
  List<({ContactModel contact, Messagemodel lastMsg})> _filtered = [];

  @override
  void initState() {
    super.initState();
    _conversations = _buildConversations();
    _filtered = _conversations;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _openDiscussion(BuildContext context, ContactModel contact) {
    final peerId = _peerIdForContact(contact);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Discussion(
          contact: contact,
          initialMessages: peerId != null ? _messagesForPeer(peerId) : [],
          currentUserId: _currentUserId,
        ),
      ),
    );
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
                  ? const Center(child: Text("Aucune conversation trouvée"))
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