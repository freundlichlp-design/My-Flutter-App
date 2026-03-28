import 'package:flutter/foundation.dart';

import '../models/subscription.dart';
import '../storage/hive_storage.dart';

class SubscriptionProvider extends ChangeNotifier {
  final HiveStorage _storage;

  Subscription _subscription;

  SubscriptionProvider({required HiveStorage storage})
      : _storage = storage,
        _subscription = storage.getSubscription();

  Subscription get subscription => _subscription;
  bool get isPremium => _subscription.isPremium;
  bool get canSendMessage => _subscription.canSendMessage;
  int get remainingMessages => _subscription.remainingMessages;
  int get dailyLimit => _subscription.dailyLimit;
  int get messagesUsedToday => _subscription.messagesUsedToday;

  Future<void> recordMessageSent() async {
    final today = DateTime.now();
    final lastReset = DateTime(
      _subscription.lastResetDate.year,
      _subscription.lastResetDate.month,
      _subscription.lastResetDate.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastReset.isBefore(todayDate)) {
      _subscription = _subscription.copyWith(
        messagesUsedToday: 1,
        lastResetDate: today,
      );
    } else {
      _subscription = _subscription.copyWith(
        messagesUsedToday: _subscription.messagesUsedToday + 1,
      );
    }

    await _storage.saveSubscription(_subscription);
    notifyListeners();
  }

  Future<void> upgradeToPremium({int days = 30}) async {
    _subscription = _subscription.copyWith(
      tier: 'premium',
      premiumExpiryDate: DateTime.now().add(Duration(days: days)),
    );
    await _storage.saveSubscription(_subscription);
    notifyListeners();
  }

  Future<void> downgradeToFree() async {
    _subscription = Subscription.initial();
    await _storage.saveSubscription(_subscription);
    notifyListeners();
  }

  Future<void> resetDailyCounter() async {
    _subscription = _subscription.copyWith(
      messagesUsedToday: 0,
      lastResetDate: DateTime.now(),
    );
    await _storage.saveSubscription(_subscription);
    notifyListeners();
  }
}
