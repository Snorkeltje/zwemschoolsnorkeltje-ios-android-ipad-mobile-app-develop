import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

enum WaitlistStatus { pending, approved, invited, expired }

class _WaitlistEntry {
  final String id;
  final String childName;
  final String location;
  final String lessonType;
  final String preferredDay;
  final String submittedDate;
  final int position;
  final WaitlistStatus status;

  const _WaitlistEntry({
    required this.id,
    required this.childName,
    required this.location,
    required this.lessonType,
    required this.preferredDay,
    required this.submittedDate,
    required this.position,
    required this.status,
  });
}

class WaitlistStatusScreen extends StatelessWidget {
  const WaitlistStatusScreen({super.key});

  List<_WaitlistEntry> get _entries => const [
        _WaitlistEntry(
          id: 'wl_001',
          childName: 'Emma Murtaza',
          location: 'De Bilt',
          lessonType: '1-op-1',
          preferredDay: 'Maandag',
          submittedDate: '15 maart 2026',
          position: 3,
          status: WaitlistStatus.pending,
        ),
        _WaitlistEntry(
          id: 'wl_002',
          childName: 'Noah Murtaza',
          location: 'Soestduinen',
          lessonType: '1-op-2',
          preferredDay: 'Woensdag',
          submittedDate: '10 maart 2026',
          position: 1,
          status: WaitlistStatus.invited,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wachtlijst status'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _entries.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              itemCount: _entries.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.md),
              itemBuilder: (context, index) {
                return _buildEntryCard(_entries[index], context);
              },
            ),
    );
  }

  Widget _buildEntryCard(_WaitlistEntry entry, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.shadowBlur,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                child: Text(
                  entry.childName.split(' ').map((w) => w[0]).take(2).join(),
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.childName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Aangemeld: ${entry.submittedDate}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(entry.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),

          // Details grid
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.location_on_outlined,
                  'Locatie',
                  entry.location,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.person_outline,
                  'Type les',
                  entry.lessonType,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.calendar_today_outlined,
                  'Voorkeur dag',
                  entry.preferredDay,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.format_list_numbered,
                  'Positie',
                  '#${entry.position} op de lijst',
                ),
              ),
            ],
          ),

          if (entry.status == WaitlistStatus.invited) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/waitlist/invitation');
                },
                child: const Text('Bekijk uitnodiging'),
              ),
            ),
          ],

          if (entry.status == WaitlistStatus.pending) ...[
            const SizedBox(height: 12),

            // Progress indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.hourglass_top,
                      size: 18, color: AppColors.warning),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'U staat op positie 3. Geschatte wachttijd: 2-4 weken.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(WaitlistStatus status) {
    Color color;
    String label;

    switch (status) {
      case WaitlistStatus.pending:
        color = AppColors.warning;
        label = 'In wacht';
        break;
      case WaitlistStatus.approved:
        color = AppColors.success;
        label = 'Goedgekeurd';
        break;
      case WaitlistStatus.invited:
        color = AppColors.primaryBlue;
        label = 'Uitgenodigd';
        break;
      case WaitlistStatus.expired:
        color = AppColors.error;
        label = 'Verlopen';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 56, color: AppColors.textLight),
          SizedBox(height: AppDimensions.md),
          Text(
            'Geen wachtlijst aanmeldingen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.xs),
          Text(
            'Meld u aan voor de wachtlijst om te starten.',
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
