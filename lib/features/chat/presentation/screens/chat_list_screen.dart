import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';

class _ChatPreview {
  final String id;
  final String instructorName;
  final String instructorInitials;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;

  const _ChatPreview({
    required this.id,
    required this.instructorName,
    required this.instructorInitials,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  List<_ChatPreview> get _conversations => const [
        _ChatPreview(
          id: 'chat_001',
          instructorName: 'Anna de Vries',
          instructorInitials: 'AV',
          lastMessage:
              'Emma heeft vandaag goed haar best gedaan met de borstcrawl!',
          timestamp: '14:32',
          unreadCount: 2,
          isOnline: true,
        ),
        _ChatPreview(
          id: 'chat_002',
          instructorName: 'Jan Bakker',
          instructorInitials: 'JB',
          lastMessage: 'De les van vrijdag is verplaatst naar 10:30.',
          timestamp: 'Gisteren',
          unreadCount: 0,
          isOnline: false,
        ),
        _ChatPreview(
          id: 'chat_003',
          instructorName: 'Lisa Jansen',
          instructorInitials: 'LJ',
          lastMessage:
              'Noah maakt goede voortgang met watergewenning. Ik stuur de oefeninstructies mee.',
          timestamp: 'Ma',
          unreadCount: 1,
          isOnline: true,
        ),
        _ChatPreview(
          id: 'chat_004',
          instructorName: 'Pieter van Dijk',
          instructorInitials: 'PD',
          lastMessage: 'Bedankt voor uw bericht. We zien u volgende week!',
          timestamp: '22 mrt',
          unreadCount: 0,
          isOnline: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Berichten'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: _conversations.length,
              separatorBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              itemBuilder: (context, index) {
                return _ChatListTile(
                  conversation: _conversations[index],
                  onTap: () {
                    context.pushNamed(
                      RouteNames.chat,
                      pathParameters: {'chatId': _conversations[index].id},
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 56, color: AppColors.textLight),
          SizedBox(height: AppDimensions.md),
          Text(
            'Geen berichten',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.xs),
          Text(
            'Uw gesprekken met instructeurs verschijnen hier.',
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

class _ChatListTile extends StatelessWidget {
  final _ChatPreview conversation;
  final VoidCallback onTap;

  const _ChatListTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: 14,
        ),
        child: Row(
          children: [
            // Instructor avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryBlue,
                  child: Text(
                    conversation.instructorInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.instructorName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              hasUnread ? FontWeight.w700 : FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        conversation.timestamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? AppColors.primaryBlue
                              : AppColors.textLight,
                          fontWeight:
                              hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: hasUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight:
                                hasUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
