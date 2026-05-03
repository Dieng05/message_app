import 'package:flutter/material.dart';
import '../../models/ContactModel.dart';

class ContactStoryItem extends StatelessWidget {
  final ContactModel contact;

  const ContactStoryItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: contact.color, width: 1),
              ),
              child: CircleAvatar(
                radius:24,
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
          const SizedBox(height: 4),
          Text(
            contact.name.split(' ')[0],
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}