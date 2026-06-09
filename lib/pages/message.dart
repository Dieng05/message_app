import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/ContactModel.dart';
import '../models/MessageModel.dart';
import '../services/ChatService.dart';
import '../services/ContactService.dart';
import '../widgets/navigation.dart';
import '../widgets/message/contact_story_item.dart';
import '../widgets/message/conversation_tile.dart';
import '../widgets/message/message_search_bar.dart';
import '../pages/discussion.dart';

String _formatTime(Timestamp? ts) {
  if (ts == null) return '';
  try {
    final dt = ts.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(msgDay).inDays;

    if (diff == 0) {
      return "${dt.hour.toString().padLeft(2, '0')}h${dt.minute.toString().padLeft(2, '0')}";
    }
    if (diff == 1) return "Hier";
    if (diff < 7) {
      const days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
      return days[dt.weekday - 1];
    }
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
  } catch (_) {
    return '';
  }
}

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<List<ContactModel>>? _contactsSub;

  late final String _currentUserId;
  Map<String, ContactModel> _contactByEmail = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.email ?? '';
    _contactsSub = ContactService.instance
        .contactsStream(_currentUserId)
        .listen((contacts) {
      if (mounted) {
        setState(() {
          _contactByEmail = {for (final c in contacts) c.email: c};
        });
      }
    });
    _searchController.addListener(
      () => setState(() => _searchQuery = _searchController.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _contactsSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _openDiscussion(BuildContext context, ContactModel contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Discussion(contact: contact)),
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
            if (_contactByEmail.isNotEmpty)
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _contactByEmail.values
                      .map((c) => ContactStoryItem(contact: c))
                      .toList(),
                ),
              ),

            const SizedBox(height: 12),
            MessageSearchBar(controller: _searchController),
            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ChatService.instance.conversationsStream(_currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  final conversations = docs
                      .map((doc) {
                        final data = doc.data();
                        final participants =
                            List<String>.from(data['participants'] ?? []);
                        final peerEmail = participants.firstWhere(
                          (p) => p != _currentUserId,
                          orElse: () => '',
                        );
                        if (peerEmail.isEmpty) return null;

                        final contact = _contactByEmail[peerEmail] ??
                            ContactModel(name: peerEmail, email: peerEmail);

                        final ts = data['lastTimestamp'] as Timestamp?;
                        final lastMsg = Messagemodel(
                          data['lastSenderId'] as String? ?? '',
                          peerEmail,
                          ts?.toDate().toIso8601String() ?? '',
                          data['lastMessage'] as String? ?? '',
                          0,
                        );

                        return (contact: contact, lastMsg: lastMsg, ts: ts);
                      })
                      .whereType<
                          ({
                            ContactModel contact,
                            Messagemodel lastMsg,
                            Timestamp? ts
                          })>()
                      .where((c) =>
                          _searchQuery.isEmpty ||
                          c.contact.name.toLowerCase().contains(_searchQuery))
                      .toList()
                    ..sort((a, b) {
                      if (a.ts == null && b.ts == null) return 0;
                      if (a.ts == null) return 1;
                      if (b.ts == null) return -1;
                      return b.ts!.compareTo(a.ts!);
                    });

                  if (conversations.isEmpty) {
                    return const Center(child: Text("Aucune conversation"));
                  }

                  return ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      return ConversationTile(
                        contact: conv.contact,
                        lastMsg: conv.lastMsg,
                        currentUserId: _currentUserId,
                        formattedTime: _formatTime(conv.ts),
                        onTap: () => _openDiscussion(context, conv.contact),
                      );
                    },
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