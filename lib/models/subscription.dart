import 'package:hive/hive.dart';

part 'subscription.g.dart';

enum SubscriptionTier { free, premium }

@HiveType(typeId: 2)
class Subscription extends HiveObject {
  @HiveField(0)
  final String tier;

  @HiveField(1)
  final int messagesUsedToday;

  @HiveField(2)
  final DateTime lastResetDate;

  @HiveField(3)
  final DateTime? premiumExpiryDate;

  static const int freeDailyLimit = 10;

  Subscription({
    required this.tier,
    this.messagesUsedToday = 0,
    DateTime? lastResetDate,
    this.premiumExpiryDate,
  }) : lastResetDate = lastResetDate ?? DateTime.now();

  SubscriptionTier get subscriptionTier =>
      tier == 'premium' ? SubscriptionTier.premium : SubscriptionTier.free;

  bool get isPremium {
    if (tier != 'premium') return false;
    if (premiumExpiryDate == null) return true;
    return premiumExpiryDate!.isAfter(DateTime.now());
  }

  bool get canSendMessage {
    if (isPremium) return true;
    return _remainingMessages > 0;
  }

  int get _remainingMessages {
    final today = DateTime.now();
    final lastReset = DateTime(lastResetDate.year, lastResetDate.month, lastResetDate.day);
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastReset.isBefore(todayDate)) {
      return freeDailyLimit;
    }
    return (freeDailyLimit - messagesUsedToday).clamp(0, freeDailyLimit);
  }

  int get remainingMessages => _remainingMessages;

  int get dailyLimit => isPremium ? -1 : freeDailyLimit;

  Subscription copyWith({
    String? tier,
    int? messagesUsedToday,
    DateTime? lastResetDate,
    DateTime? premiumExpiryDate,
  }) {
    return Subscription(
      tier: tier ?? this.tier,
      messagesUsedToday: messagesUsedToday ?? this.messagesUsedToday,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
    );
  }

  factory Subscription.initial() {
    return Subscription(
      tier: 'free',
      messagesUsedToday: 0,
      lastResetDate: DateTime.now(),
    );
  }
}
