import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/booking_model.dart';

class ReservationDetailScreen extends StatelessWidget {
  final BookingModel? booking;

  const ReservationDetailScreen({super.key, this.booking});

  // Fallback mock data when no booking is passed
  BookingModel get _booking =>
      booking ??
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
      );

  Color _lessonTypeColor(LessonType type) {
    switch (type) {
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

  Color _statusColor(BookingStatus status) {
    switch (status) {
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
    final b = _booking;
    final typeColor = _lessonTypeColor(b.lessonType);
    final sColor = _statusColor(b.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reserveringsdetails'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.cardPadding + 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [typeColor, typeColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: typeColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b.lessonTypeLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          b.statusLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('EEEE d MMMM yyyy', 'nl').format(b.date),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${b.startTime} - ${b.endTime}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Details section
            _buildDetailCard(
              children: [
                _buildDetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Locatie',
                  value: b.locationName,
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildDetailRow(
                  icon: Icons.person_outline,
                  label: 'Instructeur',
                  value: b.instructorName,
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildDetailRow(
                  icon: Icons.child_care,
                  label: 'Kind',
                  value: 'Emma', // Mock child name
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildDetailRow(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Reserveringsnummer',
                  value: '#${b.id.toUpperCase()}',
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildDetailRow(
                  icon: Icons.category_outlined,
                  label: 'Lestype',
                  value: b.lessonTypeLabel,
                  valueColor: typeColor,
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildDetailRow(
                  icon: Icons.info_outline,
                  label: 'Status',
                  value: b.statusLabel,
                  valueColor: sColor,
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Payment info
            _buildDetailCard(
              children: [
                const Row(
                  children: [
                    Icon(Icons.payment, size: 20, color: AppColors.textSecondary),
                    SizedBox(width: 10),
                    Text(
                      'Betaalinformatie',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.credit_card,
                  label: 'Betaalmethode',
                  value: 'Knipkaart',
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildDetailRow(
                  icon: Icons.receipt_outlined,
                  label: 'Knipkaart',
                  value: '10x 1-op-1 (7 resterend)',
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Cancel button (only for upcoming confirmed bookings)
            if (b.status == BookingStatus.bevestigd &&
                b.date.isAfter(DateTime.now()))
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: OutlinedButton(
                  onPressed: () => _showCancelDialog(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'Annuleer reservering',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
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
        children: children,
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          'Annuleer reservering',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Weet u zeker dat u deze reservering wilt annuleren?\n\n'
          '${_booking.lessonTypeLabel} - ${_booking.locationName}\n'
          '${DateFormat('EEEE d MMMM', 'nl').format(_booking.date)} om ${_booking.startTime}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Terug',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Call cancel booking API
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: const Text('Annuleren'),
          ),
        ],
      ),
    );
  }
}
