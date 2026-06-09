import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.grey),
          ),

          Expanded(
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Message...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: onSend,
            child: const Icon(
              Icons.send_rounded,
              color: Color(0xFFE53935),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}