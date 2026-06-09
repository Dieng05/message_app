import 'package:flutter/material.dart';
import '../../models/MessageModel.dart';

class ChatBubble extends StatelessWidget {
  final Messagemodel message;
  final bool isMine;
  final String formattedTime;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isMine ? 64 : 0,
          right: isMine ? 0 : 64,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFFE53935) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMine ? Colors.white : Colors.black87,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 11,
                    color: isMine
                        ? Colors.white.withOpacity(0.75)
                        : Colors.grey[500],
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.check,
                    size: 13,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}