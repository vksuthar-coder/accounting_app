// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});

class ProfileState {
  final String name;
  final String? avatarUrl;
  final bool notificationsEnabled;

  ProfileState({
    required this.name,
    this.avatarUrl,
    required this.notificationsEnabled,
  });

  ProfileState copyWith({
    String? name,
    String? avatarUrl,
    bool? notificationsEnabled,
  }) {
    return ProfileState(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier()
      : super(ProfileState(
          name: "Vinod Kumar",
          avatarUrl: null,
          notificationsEnabled: true,
        ));

  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  void updateAvatar(String url) {
    state = state.copyWith(avatarUrl: url);
  }

  void logout() {
    // TODO: Add real logout logic
    state = ProfileState(name: "Guest", avatarUrl: null, notificationsEnabled: false);
  }
}
