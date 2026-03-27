import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/conversation.dart';
import '../models/message.dart';
import '../services/ai_api_service.dart';
import '../services/claude_service.dart';
import '../services/gemini_service.dart';
import '../services/openai_service.dart';
import '../storage/hive_storage.dart';
import 'settings_provider.dart';

enum ChatState { idle, streaming, error }

class ChatProvider extends ChangeNotifier {
  final HiveStorage _storage;
  final SettingsProvider _settingsProvider;
  static const _uuid = Uuid();

  ChatProvider({
    required HiveStorage storage,
    required SettingsProvider settingsProvider,
  })  : _storage = storage,
        _settingsProvider = settingsProvider;

  static const int _maxMessageLength = 10000;

  List<Conversation> _conversations = [];
  Conversation? _activeConversation;
  List<Message> _messages = [];
  ChatState _state = ChatState.idle;
  String? _errorMessage;
  String _streamingContent = '';

  List<Conversation> get conversations => _conversations;
  Conversation? get activeConversation => _activeConversation;
  List<Message> get messages => _messages;
  ChatState get state => _state;
  String? get errorMessage => _errorMessage;
  String get streamingContent => _streamingContent;
  bool get isStreaming => _state == ChatState.streaming;

  void loadConversations() {
    _conversations = _storage.getAllConversations();
    notifyListeners();
  }

  Future<void> createNewConversation() async {
    final now = DateTime.now();
    final conversation = Conversation(
      id: _uuid.v4(),
      title: 'New Chat',
      createdAt: now,
      updatedAt: now,
      model: _settingsProvider.selectedModel,
      apiProvider: _settingsProvider.selectedProvider,
    );
    await _storage.saveConversation(conversation);
    _activeConversation = conversation;
    _messages = [];
    loadConversations();
  }

  Future<void> selectConversation(String id) async {
    final conversation = _storage.getConversation(id);
    if (conversation != null) {
      _activeConversation = conversation;
      _messages = _storage.getMessagesForConversation(id);
      notifyListeners();
    }
  }

  Future<void> deleteConversation(String id) async {
    await _storage.deleteConversation(id);
    if (_activeConversation?.id == id) {
      _activeConversation = null;
      _messages = [];
    }
    loadConversations();
  }

  AiApiService _createApiService() {
    final provider = _settingsProvider.selectedProvider;
    final model = _settingsProvider.selectedModel;
    final apiKey = _settingsProvider.currentApiKey;

    switch (provider) {
      case 'claude':
        return ClaudeService(apiKey: apiKey, model: model);
      case 'gemini':
        return GeminiService(apiKey: apiKey, model: model);
      default:
        return OpenAiService(apiKey: apiKey, model: model);
    }
  }

  Future<void> sendMessage(String content) async {
    // Input validation - SECURITY-C2
    if (content.trim().isEmpty) return;
    
    // Check max length
    if (content.length > _maxMessageLength) {
      _errorMessage = 'Message too long. Maximum is $_maxMessageLength characters.';
      _state = ChatState.error;
      notifyListeners();
      return;
    }

    // Check if API key is configured
    if (!_settingsProvider.isConfigured) {
      _errorMessage = 'Please configure an API key in Settings first.';
      _state = ChatState.error;
      notifyListeners();
      return;
    }

    if (_activeConversation == null) {
      await createNewConversation();
      if (_activeConversation == null) return;
    }

    final conversation = _activeConversation!;

    final userMessage = Message(
      id: _uuid.v4(),
      conversationId: conversation.id,
      role: 'user',
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    await _storage.saveMessage(userMessage);

    if (_messages.length == 1) {
      conversation.title =
          content.trim().length > 50 ? '${content.trim().substring(0, 50)}...' : content.trim();
      conversation.updatedAt = DateTime.now();
      await _storage.saveConversation(conversation);
      loadConversations();
    }

    _state = ChatState.streaming;
    _streamingContent = '';
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = _createApiService();
      final assistantMessage = Message(
        id: _uuid.v4(),
        conversationId: conversation.id,
        role: 'assistant',
        content: '',
        timestamp: DateTime.now(),
      );

      _messages.add(assistantMessage);
      notifyListeners();

      await for (final chunk
          in apiService.sendMessage(
        _messages.sublist(0, _messages.length - 1),
        systemPrompt: _settingsProvider.selectedPersonality.systemPrompt,
      )) {
        _streamingContent += chunk;
        assistantMessage.content = _streamingContent;
        notifyListeners();
      }

      await _storage.saveMessage(assistantMessage);

      conversation.updatedAt = DateTime.now();
      await _storage.saveConversation(conversation);
      loadConversations();

      _state = ChatState.idle;
      _streamingContent = '';
    } catch (e) {
      _state = ChatState.error;
      _errorMessage = e.toString();
      if (_messages.isNotEmpty && _messages.last.content.isEmpty) {
        _messages.removeLast();
      }
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _state = ChatState.idle;
    notifyListeners();
  }
}
