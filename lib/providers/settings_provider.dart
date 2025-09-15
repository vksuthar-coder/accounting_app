// lib/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);

class SettingsState {
  final bool darkMode;
  final bool notificationsEnabled;
  final String language;

  SettingsState({
    required this.darkMode,
    required this.notificationsEnabled,
    required this.language,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? language,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
          darkMode: false,
          notificationsEnabled: true,
          language: "English",
        ));

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  void setLanguage(String newLang) {
    state = state.copyWith(language: newLang);
  }
}
