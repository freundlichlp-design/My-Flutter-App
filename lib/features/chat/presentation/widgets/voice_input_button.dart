import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../services/voice_service.dart';
import '../../../../theme/kali_colors.dart';

class VoiceInputButton extends StatefulWidget {
  final ValueChanged<String> onTextRecognized;
  final bool enabled;

  const VoiceInputButton({
    super.key,
    required this.onTextRecognized,
    this.enabled = true,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  final VoiceService _voiceService = VoiceService();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  StreamSubscription<VoiceState>? _stateSub;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _stateSub = _voiceService.stateStream.listen((state) {
      final listening = state == VoiceState.listening;
      if (listening != _isListening) {
        setState(() => _isListening = listening);
      }
      if (listening) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (!widget.enabled) return;

    if (_voiceService.isListening) {
      await _voiceService.stopListening();
      if (_voiceService.lastRecognizedText.isNotEmpty) {
        widget.onTextRecognized(_voiceService.lastRecognizedText);
      }
    } else {
      await _voiceService.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _isListening ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _isListening
              ? KaliColors.accentDanger
              : (widget.enabled
                  ? KaliColors.bgTertiary
                  : KaliColors.borderColor),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: widget.enabled ? _toggleListening : null,
          icon: Icon(
            _isListening ? Icons.stop : Icons.mic,
            color: KaliColors.textInverse,
            size: 20,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
