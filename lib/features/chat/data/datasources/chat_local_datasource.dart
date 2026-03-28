import 'package:hive_flutter/hive_flutter.dart';

import '../../../../models/conversation.dart';
import '../../../../models/message.dart';

class ChatLocalDatasource {
  static const String conversationsBox = 'conversations';
  static const String messagesBox = 'messages';

  Box<Conversation> get _conversationBox =>
      Hive.box<Conversation>(conversationsBox);

  Box<Message> get _messageBox => Hive.box<Message>(messagesBox);

  List<Conversation> getAllConversations() {
    final list = _conversationBox.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  Conversation? getConversation(String id) {
    return _conversationBox.get(id);
  }

  Future<void> saveConversation(Conversation conversation) async {
    await _conversationBox.put(conversation.id, conversation);
  }

  Future<void> deleteConversation(String id) async {
    final messagesToDelete = _messageBox.values
        .where((m) => m.conversationId == id)
        .toList();
    for (final msg in messagesToDelete) {
      await msg.delete();
    }
    await _conversationBox.delete(id);
  }

  List<Message> getMessagesForConversation(String conversationId) {
    final list = _messageBox.values
        .where((m) => m.conversationId == conversationId)
        .toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  Future<void> saveMessage(Message message) async {
    await _messageBox.put(message.id, message);
  }

  Future<void> clearAll() async {
    await _conversationBox.clear();
    await _messageBox.clear();
  }
}
