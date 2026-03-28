import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

class BookingTypeScreen extends StatelessWidget {
  const BookingTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.selectLessonType),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welk type les wilt u boeken?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Lesson type cards
            _LessonTypeCard(
              icon: Icons.event,
              title: AppStrings.fixedSlot,
              subtitle: AppStrings.fixedSlotDesc,
              color: AppColors.lessonFixed,
              onTap: () {
                // TODO: Navigate to fixed slot calendar
              },
            ),
            const SizedBox(height: AppDimensions.md),
            _LessonTypeCard(
              icon: Icons.person,
              title: AppStrings.extra1on1,
              subtitle: AppStrings.extra1on1Desc,
              color: AppColors.lessonExtra1on1,
              onTap: () {
                // TODO: Navigate to extra 1-on-1 booking
              },
            ),
            const SizedBox(height: AppDimensions.md),
            _LessonTypeCard(
              icon: Icons.people,
              title: AppStrings.extra1on2,
              subtitle: AppStrings.extra1on2Desc,
              color: AppColors.lessonExtra1on2,
              onTap: () {
                // TODO: Navigate to extra 1-on-2 booking
              },
            ),
            const SizedBox(height: AppDimensions.md),
            _LessonTypeCard(
              icon: Icons.beach_access,
              title: AppStrings.holidayLesson,
              subtitle: AppStrings.holidayLessonDesc,
              color: AppColors.lessonHoliday,
              onTap: () {
                // TODO: Navigate to holiday booking
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LessonTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
