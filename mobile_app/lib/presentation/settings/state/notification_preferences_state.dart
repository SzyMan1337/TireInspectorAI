import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  final bool isEnabled;

  NotificationPreferences({this.isEnabled = true});

  NotificationPreferences copyWith({bool? isEnabled}) {
    return NotificationPreferences(
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

final notificationPreferencesStateProvider = StateNotifierProvider<
    NotificationPreferencesStateNotifier, NotificationPreferences>(
  (ref) => NotificationPreferencesStateNotifier(),
);

class NotificationPreferencesStateNotifier
    extends StateNotifier<NotificationPreferences> {
  static const String _notificationsKey = 'notifications_enabled';

  NotificationPreferencesStateNotifier() : super(NotificationPreferences()) {
    _loadNotificationPreferences();
  }

  Future<void> _loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_notificationsKey) ?? true;
    state = state.copyWith(isEnabled: isEnabled);
  }

  void setNotificationEnabled(bool isEnabled) async {
    state = state.copyWith(isEnabled: isEnabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, isEnabled);
  }
}
