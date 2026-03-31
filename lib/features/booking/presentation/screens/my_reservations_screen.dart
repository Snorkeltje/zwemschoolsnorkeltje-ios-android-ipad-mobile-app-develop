import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/booking_model.dart';
import 'reservation_detail_screen.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data - replace with provider/API call
  final List<BookingModel> _upcomingBookings = [
    BookingModel(
      id: 'bk_001',
      childId: 'child_001',
      locationId: 'loc_001',
      timeSlotId: 'ts_001',
      lessonType: LessonType.vastTijdstip,
      status: BookingStatus.bevestigd,
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: '15:00',
      endTime: '15:30',
      instructorName: 'Anna de Vries',
      locationName: 'De Bilt',
    ),
    BookingModel(
      id: 'bk_002',
      childId: 'child_001',
      locationId: 'loc_002',
      timeSlotId: 'ts_002',
      lessonType: LessonType.extra1op1,
      status: BookingStatus.bevestigd,
      date: DateTime.now().add(const Duration(days: 7)),
      startTime: '10:00',
      endTime: '10:30',
      instructorName: 'Jan Bakker',
      locationName: 'Soestduinen',
    ),
    BookingModel(
      id: 'bk_003',
      childId: 'child_002',
      locationId: 'loc_001',
      timeSlotId: 'ts_003',
      lessonType: LessonType.extra1op2,
      status: BookingStatus.bevestigd,
      date: DateTime.now().add(const Duration(days: 10)),
      startTime: '14:00',
      endTime: '14:30',
      instructorName: 'Lisa Jansen',
      locationName: 'Nijkerk',
    ),
  ];

  final List<BookingModel> _historyBookings = [
    BookingModel(
      id: 'bk_010',
      childId: 'child_001',
      locationId: 'loc_001',
      timeSlotId: 'ts_010',
      lessonType: LessonType.vastTijdstip,
      status: BookingStatus.aanwezig,
      date: DateTime.now().subtract(const Duration(days: 3)),
      startTime: '15:00',
      endTime: '15:30',
      instructorName: 'Anna de Vries',
      locationName: 'De Bilt',
    ),
    BookingModel(
      id: 'bk_011',
      childId: 'child_001',
      locationId: 'loc_002',
      timeSlotId: 'ts_011',
      lessonType: LessonType.extra1op1,
      status: BookingStatus.geannuleerd,
      date: DateTime.now().subtract(const Duration(days: 7)),
      startTime: '10:00',
      endTime: '10:30',
      instructorName: 'Jan Bakker',
      locationName: 'Soestduinen',
    ),
    BookingModel(
      id: 'bk_012',
      childId: 'child_002',
      locationId: 'loc_001',
      timeSlotId: 'ts_012',
      lessonType: LessonType.vastTijdstip,
      status: BookingStatus.aanwezig,
      date: DateTime.now().subtract(const Duration(days: 10)),
      startTime: '14:00',
      endTime: '14:30',
      instructorName: 'Lisa Jansen',
      locationName: 'De Bilt',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.myReservations),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: AppStrings.upcoming),
            Tab(text: AppStrings.history),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(_upcomingBookings, isUpcoming: true),
          _buildBookingList(_historyBookings, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings,
      {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return _buildEmptyState(isUpcoming);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.md),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReservationDetailScreen(
                  booking: bookings[index],
                ),
              ),
            );
          },
          child: _BookingCard(
            booking: bookings[index],
            isUpcoming: isUpcoming,
            onCancel: isUpcoming
                ? () => _showCancelDialog(bookings[index])
                : null,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isUpcoming) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.history,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              isUpcoming
                  ? 'Geen geplande reserveringen'
                  : 'Geen geschiedenis beschikbaar',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              isUpcoming
                  ? 'Boek een les om te beginnen!'
                  : 'Uw voltooide lessen verschijnen hier.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (isUpcoming) ...[
              const SizedBox(height: AppDimensions.lg),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textWhite,
                  minimumSize:
                      const Size(200, AppDimensions.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Text(
                  AppStrings.bookLesson,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          AppStrings.cancelReservation,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '${AppStrings.cancelConfirm}\n\n'
          '${booking.lessonTypeLabel} - ${booking.locationName}\n'
          '${DateFormat('EEEE d MMMM', 'nl').format(booking.date)} om ${booking.startTime}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              AppStrings.back,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Call cancel booking API
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: const Text(AppStrings.cancel),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isUpcoming;
  final VoidCallback? onCancel;

  const _BookingCard({
    required this.booking,
    required this.isUpcoming,
    this.onCancel,
  });

  Color get _lessonTypeColor {
    switch (booking.lessonType) {
      case LessonType.vastTijdstip:
        return AppColors.lessonFixed;
      case LessonType.extra1op1:
        return AppColors.lessonExtra1on1;
      case LessonType.extra1op2:
        return AppColors.lessonExtra1on2;
      case LessonType.vakantie:
        return AppColors.lessonHoliday;
    }
  }

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.bevestigd:
        return AppColors.success;
      case BookingStatus.geannuleerd:
        return AppColors.error;
      case BookingStatus.aanwezig:
        return AppColors.primaryBlue;
      case BookingStatus.nietVerschenen:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Left color strip
          Container(
            width: 4,
            height: 140,
            decoration: BoxDecoration(
              color: _lessonTypeColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                bottomLeft: Radius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lesson type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _lessonTypeColor.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          booking.lessonTypeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _lessonTypeColor,
                          ),
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          booking.statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    booking.locationName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('EEEE d MMMM yyyy', 'nl')
                            .format(booking.date),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        booking.displayTime,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.person_outline,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        booking.instructorName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (isUpcoming && booking.canCancel) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: onCancel,
                        child: const Text(
                          AppStrings.cancelReservation,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
