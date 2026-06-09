import 'package:flutter/material.dart';
import '../pages/add_contact.dart';
import '../widgets/contact/list_contact.dart';
import '../widgets/navigation.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  int _listKey = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _searchQuery = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[400],
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: "rechercher",
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 16),

            Expanded(
              child: ListContact(key: ValueKey(_listKey), searchQuery: _searchQuery),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[300],
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContact()),
          );
          if (added == true) setState(() => _listKey++);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}