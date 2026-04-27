import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/notifications_repository.dart';
import '../providers/notifications_provider.dart';

/// Real-time per-user notifications backed by Supabase `notifications` table.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);
    final list = async.value ?? const <AppNotification>[];

    final today = list.where((n) => DateTime.now().difference(n.createdAt).inDays < 1).toList();
    final earlier = list.where((n) => DateTime.now().difference(n.createdAt).inDays >= 1).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Color(0xFF131827), size: 22),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Meldingen',
                        style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    await ref.read(notificationsRepoProvider).markAllRead();
                    ref.invalidate(notificationsProvider);
                    ref.invalidate(unreadCountProvider);
                  },
                  child: const Text('Alles gelezen',
                      style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(notificationsProvider);
                await ref.read(notificationsProvider.future);
              },
              child: async.isLoading && list.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : list.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.notifications_off_outlined,
                                      size: 48, color: Colors.black.withValues(alpha: 0.15)),
                                  const SizedBox(height: 12),
                                  const Text('Geen meldingen',
                                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (today.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text('Vandaag',
                                      style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                                ),
                                ...today.map((n) => _Card(notif: n)),
                                const SizedBox(height: 16),
                              ],
                              if (earlier.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text('Eerder',
                                      style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                                ),
                                ...earlier.map((n) => _Card(notif: n)),
                              ],
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends ConsumerWidget {
  final AppNotification notif;
  const _Card({required this.notif});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () async {
          if (!notif.read) {
            await ref.read(notificationsRepoProvider).markRead(notif.id);
            ref.invalidate(notificationsProvider);
            ref.invalidate(unreadCountProvider);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: notif.read ? Colors.white : const Color(0xFFF4F7FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (!notif.read)
                Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(color: notif.color, shape: BoxShape.circle),
                ),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: notif.color.withValues(alpha: 0.1), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(notif.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif.title,
                        style: TextStyle(
                          color: const Color(0xFF131827),
                          fontSize: 13,
                          fontWeight: notif.read ? FontWeight.normal : FontWeight.w700,
                        )),
                    Text(notif.body,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF818EA6), fontSize: 11)),
                  ],
                ),
              ),
              Text(notif.relativeTime(),
                  style: const TextStyle(color: Color(0xFF818EA6), fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
