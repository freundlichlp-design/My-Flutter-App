import 'package:hive_flutter/hive_flutter.dart';

import '../models/conversation.dart';
import '../models/message.dart';

class StorageService {
  static const String _conversationsBoxName = 'conversations';
  static const String _messagesBoxName = 'messages';

  late Box<Conversation> _conversationsBox;
  late Box<Message> _messagesBox;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MessageAdapter());
    }

    // Open boxes
    _conversationsBox = await Hive.openBox<Conversation>(_conversationsBoxName);
    _messagesBox = await Hive.openBox<Message>(_messagesBoxName);

    _isInitialized = true;
  }

  // Conversation CRUD
  Future<void> saveConversation(Conversation conversation) async {
    await _conversationsBox.put(conversation.id, conversation);
  }

  Future<void> deleteConversation(String id) async {
    await _conversationsBox.delete(id);
    // Delete all messages in this conversation
    final messagesToDelete = _messagesBox.values
        .where((m) => m.conversationId == id)
        .map((m) => m.id)
        .toList();
    for (final messageId in messagesToDelete) {
      await _messagesBox.delete(messageId);
    }
  }

  List<Conversation> getAllConversations() {
    return _conversationsBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Conversation? getConversation(String id) {
    return _conversationsBox.get(id);
  }

  // Message CRUD
  Future<void> saveMessage(Message message) async {
    await _messagesBox.put(message.id, message);
  }

  Future<void> deleteMessage(String id) async {
    await _messagesBox.delete(id);
  }

  List<Message> getMessagesForConversation(String conversationId) {
    return _messagesBox.values
        .where((m) => m.conversationId == conversationId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> deleteAllMessagesInConversation(String conversationId) async {
    final messagesToDelete = _messagesBox.values
        .where((m) => m.conversationId == conversationId)
        .map((m) => m.id)
        .toList();
    for (final messageId in messagesToDelete) {
      await _messagesBox.delete(messageId);
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    await _conversationsBox.clear();
    await _messagesBox.clear();
  }
}