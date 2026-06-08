import 'package:flutter/material.dart';
import '../Config/SQLdb.dart';
import '../Config/SessionManager.dart';
import '../models/ContactModel.dart';
import '../models/MessageModel.dart';
import '../widgets/discussion/chat_bubble.dart';
import '../widgets/discussion/chat_input_bar.dart';


String _formatTime(String timestamp) {
  try {
    final dt = DateTime.parse(timestamp);
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return "Il y a ${diff.inMinutes} min";
    if (diff.inHours < 24) {
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays} jours";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
  } catch (_) {
    return timestamp;
  }
}


class Discussion extends StatefulWidget {

  final ContactModel contact;

  final List<Messagemodel> initialMessages;

  final String currentUserId;

  const Discussion({
    super.key,
    required this.contact,
    this.initialMessages = const [],
    this.currentUserId = "me",
  });

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Sqldb _sqldb = Sqldb();
  List<Messagemodel> _messages = [];
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    _currentUserId = widget.currentUserId.isNotEmpty
        ? widget.currentUserId
        : (await SessionManager.getCurrentUserEmail() ?? '');

    final rows = await _sqldb.readMessagesByPeer(
      currentUserId: _currentUserId,
      peerId: widget.contact.phone,
    );
    if (mounted) {
      setState(() {
        _messages = rows.map((r) => Messagemodel(
          r['idFrom'] as String,
          r['idTo'] as String,
          r['timestamp'] as String,
          r['content'] as String,
          r['type'] as int,
        )).toList();
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final timestamp = DateTime.now().toIso8601String();

    await _sqldb.insertMessage(
      idFrom: _currentUserId,
      idTo: widget.contact.phone,
      timestamp: timestamp,
      content: text,
      type: 0,
    );

    setState(() {
      _messages.add(
        Messagemodel(_currentUserId, widget.contact.phone, timestamp, text, 0),
      );
    });

    _inputController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const BackButton(),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: widget.contact.color.withOpacity(0.15),
              child: Text(
                widget.contact.initial,
                style: TextStyle(
                  color: widget.contact.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.contact.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: _messages.isEmpty
                ? Center(
              child: Text(
                "Aucun message",
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMine = msg.idFrom == _currentUserId;
                return ChatBubble(
                  message: msg,
                  isMine: isMine,
                  formattedTime: _formatTime(msg.timestamp),
                );
              },
            ),
          ),


          ChatInputBar(
            controller: _inputController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}