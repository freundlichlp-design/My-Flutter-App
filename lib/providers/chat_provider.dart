import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../features/chat/domain/entities/conversation.dart';
import '../../features/chat/domain/entities/message.dart';
import '../../features/chat/domain/usecases/create_conversation.dart';
import '../../features/chat/domain/usecases/delete_conversation.dart';
import '../../features/chat/domain/usecases/load_conversations.dart';
import '../../features/chat/domain/usecases/send_message.dart';
import '../../features/chat/domain/usecases/stream_response.dart';
import '../../features/settings/domain/entities/api_key_config.dart';
import '../../features/settings/domain/entities/personality.dart';
import '../../features/settings/domain/entities/provider_config.dart';
import '../../services/emotion_engine.dart';

enum ChatState { idle, streaming, error }

class ChatProvider extends ChangeNotifier {
  final LoadConversations _loadConversations;
  final CreateConversation _createConversation;
  final DeleteConversation _deleteConversation;
  final SendMessage _sendMessage;
  final StreamResponse _streamResponse;

  static const _uuid = Uuid();

  ChatProvider({
    required LoadConversations loadConversations,
    required CreateConversation createConversation,
    required DeleteConversation deleteConversation,
    required SendMessage sendMessage,
    required StreamResponse streamResponse,
  })  : _loadConversations = loadConversations,
        _createConversation = createConversation,
        _deleteConversation = deleteConversation,
        _sendMessage = sendMessage,
        _streamResponse = streamResponse;

  List<ConversationEntity> _conversations = [];
  ConversationEntity? _activeConversation;
  List<MessageEntity> _messages = [];
  ChatState _state = ChatState.idle;
  String? _errorMessage;
  String _streamingContent = '';

  List<ConversationEntity> get conversations => _conversations;
  ConversationEntity? get activeConversation => _activeConversation;
  List<MessageEntity> get messages => _messages;
  ChatState get state => _state;
  String? get errorMessage => _errorMessage;
  String get streamingContent => _streamingContent;
  bool get isStreaming => _state == ChatState.streaming;

  Future<void> loadConversations() async {
    final result = await _loadConversations();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (conversations) {
        _conversations = conversations;
        notifyListeners();
      },
    );
  }

  Future<void> createNewConversation({
    required String model,
    required String apiProvider,
  }) async {
    final now = DateTime.now();
    final conversation = ConversationEntity(
      id: _uuid.v4(),
      title: 'New Chat',
      createdAt: now,
      updatedAt: now,
      model: model,
      apiProvider: apiProvider,
    );

    final result = await _createConversation(conversation);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _activeConversation = conversation;
        _messages = [];
        loadConversations();
      },
    );
  }

  Future<void> selectConversation(String id) async {
    final convResult = _conversations.where((c) => c.id == id).toList();
    if (convResult.isNotEmpty) {
      _activeConversation = convResult.first;
      notifyListeners();
    }
  }

  Future<void> deleteConversation(String id) async {
    final result = await _deleteConversation(id);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        if (_activeConversation?.id == id) {
          _activeConversation = null;
          _messages = [];
        }
        loadConversations();
      },
    );
  }

  Future<void> sendMessage(
    String content, {
    required ApiKeyConfigEntity apiKeys,
    required ProviderConfigEntity providerConfig,
    required PersonalityEntity personality,
  }) async {
    if (content.trim().isEmpty) return;

    if (content.length > 10000) {
      _errorMessage = 'Message too long. Maximum is 10000 characters.';
      _state = ChatState.error;
      notifyListeners();
      return;
    }

    final apiKey = apiKeys.getKeyForProvider(providerConfig.selectedProvider);
    if (apiKey.isEmpty) {
      _errorMessage = 'Please configure an API key in Settings first.';
      _state = ChatState.error;
      notifyListeners();
      return;
    }

    if (_activeConversation == null) {
      await createNewConversation(
        model: providerConfig.selectedModel,
        apiProvider: providerConfig.selectedProvider,
      );
      if (_activeConversation == null) return;
    }

    final conversation = _activeConversation!;

    final userMessageResult = await _sendMessage(
      content: content,
      conversation: conversation,
      provider: providerConfig.selectedProvider,
      apiKey: apiKey,
      model: providerConfig.selectedModel,
    );

    userMessageResult.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = ChatState.error;
        notifyListeners();
      },
      (userMessage) async {
        _messages.add(userMessage);
        notifyListeners();

        if (_messages.length == 1) {
          final updatedConv = ConversationEntity(
            id: conversation.id,
            title: content.trim().length > 50
                ? '${content.trim().substring(0, 50)}...'
                : content.trim(),
            createdAt: conversation.createdAt,
            updatedAt: DateTime.now(),
            model: conversation.model,
            apiProvider: conversation.apiProvider,
          );
          await _createConversation(updatedConv);
          _activeConversation = updatedConv;
          loadConversations();
        }

        _state = ChatState.streaming;
        _streamingContent = '';
        _errorMessage = null;
        notifyListeners();

        try {
          final assistantMessage = MessageEntity(
            id: _uuid.v4(),
            conversationId: conversation.id,
            role: 'assistant',
            content: '',
            timestamp: DateTime.now(),
          );

          _messages.add(assistantMessage);
          notifyListeners();

          final messagesForApi = _messages.sublist(0, _messages.length - 1);

          final emotionContext = EmotionEngine.analyze(messagesForApi);
          final emotionalPrompt = EmotionEngine.buildEmotionalContext(emotionContext);
          String systemPrompt = personality.systemPrompt;
          if (emotionalPrompt.isNotEmpty) {
            systemPrompt = '$systemPrompt\n\n$emotionalPrompt';
          }

          await for (final chunk in _streamResponse(
            history: messagesForApi,
            systemPrompt: systemPrompt,
            provider: providerConfig.selectedProvider,
            apiKey: apiKey,
            model: providerConfig.selectedModel,
          )) {
            chunk.fold(
              (failure) {
                throw Exception(failure.message);
              },
              (text) {
                _streamingContent += text;
                final updatedMessage = MessageEntity(
                  id: assistantMessage.id,
                  conversationId: assistantMessage.conversationId,
                  role: assistantMessage.role,
                  content: _streamingContent,
                  timestamp: assistantMessage.timestamp,
                  tokens: assistantMessage.tokens,
                );
                _messages[_messages.length - 1] = updatedMessage;
                notifyListeners();
              },
            );
          }

          final finalMessage = _messages.last;
          final result = await _sendMessage(
            content: finalMessage.content,
            conversation: conversation,
            provider: providerConfig.selectedProvider,
            apiKey: apiKey,
            model: providerConfig.selectedModel,
          );
          result.fold(
            (_) {},
            (_) {},
          );

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
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    _state = ChatState.idle;
    notifyListeners();
  }
}
