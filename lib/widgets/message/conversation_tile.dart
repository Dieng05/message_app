import 'package:flutter/material.dart';
import '../../models/ContactModel.dart';
import '../../models/MessageModel.dart';

class ConversationTile extends StatelessWidget {
  final ContactModel contact;
  final Messagemodel lastMsg;
  final String currentUserId;
  final String formattedTime;
  final VoidCallback? onTap;
  final bool isUnknown;
  final VoidCallback? onAddContact;

  const ConversationTile({
    super.key,
    required this.contact,
    required this.lastMsg,
    required this.currentUserId,
    required this.formattedTime,
    this.onTap,
    this.isUnknown = false,
    this.onAddContact,
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

      trailing: isUnknown
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                GestureDetector(
                  onTap: onAddContact,
                  child: Icon(Icons.person_add_outlined,
                      size: 20, color: Colors.red[300]),
                ),
              ],
            )
          : Text(
              formattedTime,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

      onTap: onTap,
    );
  }
}