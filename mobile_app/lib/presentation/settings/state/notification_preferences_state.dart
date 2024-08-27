import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPreferences {
  final bool isEnabled;

  NotificationPreferences({this.isEnabled = true});
}

final notificationPreferencesStateProvider = StateNotifierProvider<
    NotificationPreferencesState, NotificationPreferences>(
  (ref) => NotificationPreferencesState(),
);

class NotificationPreferencesState
    extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesState() : super(NotificationPreferences());

  void setNotificationEnabled(bool isEnabled) {
    state = NotificationPreferences(isEnabled: isEnabled);
  }
}
