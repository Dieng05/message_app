import 'package:flutter/material.dart';
import '../../models/ContactModel.dart';
import '../../models/MessageModel.dart';

class ConversationTile extends StatelessWidget {
  final ContactModel contact;
  final Messagemodel lastMsg;
  final String currentUserId;
  final String formattedTime;
  final VoidCallback? onTap;

  const ConversationTile({
    super.key,
    required this.contact,
    required this.lastMsg,
    required this.currentUserId,
    required this.formattedTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = lastMsg.idFrom == currentUserId;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6.0),

      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: contact.color, width: 1),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Text(
              contact.initial,
              style: TextStyle(
                color: contact.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        isMine ? "moi : ${lastMsg.content}" : lastMsg.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[900]),
      ),

      trailing: Text(
        formattedTime,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),

      onTap: onTap,
    );
  }
}