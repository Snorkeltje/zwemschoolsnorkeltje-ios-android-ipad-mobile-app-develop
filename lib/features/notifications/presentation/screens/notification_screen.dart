import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

enum NotificationType { booking, payment, progress, chat, reminder }

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final NotificationType type;
  final bool isRead;
  final String group; // 'Vandaag', 'Gisteren', 'Eerder'

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.group,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<_NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      // Vandaag
      const _NotificationItem(
        id: 'n_001',
        title: 'Les bevestigd',
        message: 'Uw les op maandag 31 maart om 15:00 is bevestigd.',
        timestamp: '14:30',
        type: NotificationType.booking,
        group: 'Vandaag',
        isRead: false,
      ),
      const _NotificationItem(
        id: 'n_002',
        title: 'Nieuw bericht van Anna',
        message:
            'Anna de Vries heeft u een bericht gestuurd over de voortgang van Emma.',
        timestamp: '11:15',
        type: NotificationType.chat,
        group: 'Vandaag',
        isRead: false,
      ),
      const _NotificationItem(
        id: 'n_003',
        title: 'Voortgang bijgewerkt',
        message:
            'De voortgang van Emma is bijgewerkt. Bekijk de nieuwe vaardigheden.',
        timestamp: '09:00',
        type: NotificationType.progress,
        group: 'Vandaag',
        isRead: true,
      ),
      // Gisteren
      const _NotificationItem(
        id: 'n_004',
        title: 'Betaling ontvangen',
        message: 'Uw betaling van \u20AC30,50 voor de zwemles is ontvangen.',
        timestamp: '16:45',
        type: NotificationType.payment,
        group: 'Gisteren',
        isRead: true,
      ),
      const _NotificationItem(
        id: 'n_005',
        title: 'Herinnering: les morgen',
        message:
            'Vergeet niet: u heeft morgen een zwemles om 15:00 bij De Bilt.',
        timestamp: '18:00',
        type: NotificationType.reminder,
        group: 'Gisteren',
        isRead: true,
      ),
      // Eerder
      const _NotificationItem(
        id: 'n_006',
        title: 'Knipkaart bijna op',
        message:
            'U heeft nog 2 lessen over op uw 1-op-1 knipkaart. Koop een nieuwe kaart.',
        timestamp: '25 mrt',
        type: NotificationType.payment,
        group: 'Eerder',
        isRead: true,
      ),
      const _NotificationItem(
        id: 'n_007',
        title: 'Nieuw niveau bereikt!',
        message:
            'Gefeliciteerd! Emma is naar het niveau Beginner 2 gegaan.',
        timestamp: '22 mrt',
        type: NotificationType.progress,
        group: 'Eerder',
        isRead: true,
      ),
    ];
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) {
        if (!n.isRead) {
          return _NotificationItem(
            id: n.id,
            title: n.title,
            message: n.message,
            timestamp: n.timestamp,
            type: n.type,
            group: n.group,
            isRead: true,
          );
        }
        return n;
      }).toList();
    });
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.event;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.progress:
        return Icons.trending_up;
      case NotificationType.chat:
        return Icons.chat_bubble_outline;
      case NotificationType.reminder:
        return Icons.alarm;
    }
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return AppColors.primaryBlue;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.progress:
        return AppColors.primaryOrange;
      case NotificationType.chat:
        return const Color(0xFF8B5CF6); // purple
      case NotificationType.reminder:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = _notifications.any((n) => !n.isRead);
    final groups = ['Vandaag', 'Gisteren', 'Eerder'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meldingen'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Alles gelezen',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, groupIndex) {
                final group = groups[groupIndex];
                final items = _notifications
                    .where((n) => n.group == group)
                    .toList();
                if (items.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.screenPadding,
                        AppDimensions.md,
                        AppDimensions.screenPadding,
                        AppDimensions.sm,
                      ),
                      child: Text(
                        group,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    // Items
                    ...items.map((item) => _buildNotificationTile(item)),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildNotificationTile(_NotificationItem item) {
    return Container(
      color: item.isRead ? AppColors.white : AppColors.primaryBlue.withValues(alpha: 0.03),
      child: InkWell(
        onTap: () {
          // TODO: Navigate based on notification type
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread indicator
              if (!item.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 16),

              // Type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _colorForType(item.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  _iconForType(item.type),
                  color: _colorForType(item.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          item.timestamp,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 56, color: AppColors.textLight),
          SizedBox(height: AppDimensions.md),
          Text(
            'Geen meldingen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.xs),
          Text(
            'U bent helemaal bij!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
