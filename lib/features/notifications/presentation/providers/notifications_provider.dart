import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/notifications_repository.dart';

final notificationsRepoProvider = Provider<NotificationsRepository>(
  (_) => NotificationsRepository(Supabase.instance.client),
);

final notificationsProvider = FutureProvider<List<AppNotification>>(
  (ref) => ref.read(notificationsRepoProvider).fetchForCurrentUser(),
);

final unreadCountProvider = FutureProvider<int>(
  (ref) => ref.read(notificationsRepoProvider).unreadCount(),
);
