import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/MessageModel.dart';

class ChatService {
  static final ChatService instance = ChatService._();
  ChatService._();

  final _db = FirebaseFirestore.instance;

  // Clé déterministe : les deux appareils calculent le même ID sans coordination
  static String conversationId(String emailA, String emailB) {
    final sorted = [emailA, emailB]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> sendMessage({
    required String convId,
    required String idFrom,
    required String idTo,
    required String content,
  }) async {
    final ts = Timestamp.now();
    final batch = _db.batch();

    final msgRef = _db
        .collection('conversations')
        .doc(convId)
        .collection('messages')
        .doc();

    batch.set(msgRef, {
      'idFrom': idFrom,
      'idTo': idTo,
      'content': content,
      'timestamp': ts,
      'type': 0,
    });

    batch.set(
      _db.collection('conversations').doc(convId),
      {
        'participants': [idFrom, idTo],
        'lastMessage': content,
        'lastTimestamp': ts,
        'lastSenderId': idFrom,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Stream<List<Messagemodel>> messagesStream(String convId) {
    return _db
        .collection('conversations')
        .doc(convId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final d = doc.data();
              return Messagemodel(
                d['idFrom'] as String,
                d['idTo'] as String,
                (d['timestamp'] as Timestamp).toDate().toIso8601String(),
                d['content'] as String,
                (d['type'] as int?) ?? 0,
              );
            }).toList());
  }

  // Pas d'orderBy pour éviter l'index composite Firestore — tri côté client
  Stream<QuerySnapshot<Map<String, dynamic>>> conversationsStream(String userEmail) {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: userEmail)
        .snapshots();
  }
}