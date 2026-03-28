import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/time_slot_model.dart';

class FixedSlotCalendarScreen extends StatefulWidget {
  const FixedSlotCalendarScreen({super.key});

  @override
  State<FixedSlotCalendarScreen> createState() =>
      _FixedSlotCalendarScreenState();
}

class _FixedSlotCalendarScreenState extends State<FixedSlotCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedSlotId;

  // Mock available dates (within 14-day window)
  late final Set<DateTime> _availableDates;
  late final Set<DateTime> _fullDates;

  // Mock time slots for selected date
  final Map<String, List<TimeSlotModel>> _slotsByDate = {};

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();

    _availableDates = {
      now.add(const Duration(days: 2)),
      now.add(const Duration(days: 5)),
      now.add(const Duration(days: 7)),
      now.add(const Duration(days: 9)),
      now.add(const Duration(days: 12)),
    }.map((d) => DateTime(d.year, d.month, d.day)).toSet();

    _fullDates = {
      now.add(const Duration(days: 3)),
      now.add(const Duration(days: 6)),
    }.map((d) => DateTime(d.year, d.month, d.day)).toSet();

    // Slots for some dates
    for (final date in _availableDates) {
      final key = DateFormat('yyyy-MM-dd').format(date);
      _slotsByDate[key] = [
        TimeSlotModel(
          id: 'ts_${key}_1',
          startTime: '09:00',
          endTime: '09:30',
          instructorName: 'Anna de Vries',
          availableSpots: 1,
          maxSpots: 1,
          isAvailable: true,
        ),
        TimeSlotModel(
          id: 'ts_${key}_2',
          startTime: '10:00',
          endTime: '10:30',
          instructorName: 'Jan Bakker',
          availableSpots: 1,
          maxSpots: 1,
          isAvailable: true,
        ),
        TimeSlotModel(
          id: 'ts_${key}_3',
          startTime: '14:00',
          endTime: '14:30',
          instructorName: 'Lisa Jansen',
          availableSpots: 0,
          maxSpots: 1,
          isAvailable: false,
        ),
        TimeSlotModel(
          id: 'ts_${key}_4',
          startTime: '15:00',
          endTime: '15:30',
          instructorName: 'Anna de Vries',
          availableSpots: 1,
          maxSpots: 1,
          isAvailable: true,
        ),
      ];
    }
  }

  List<TimeSlotModel> _getSlotsForDay(DateTime day) {
    final key = DateFormat('yyyy-MM-dd').format(day);
    return _slotsByDate[key] ?? [];
  }

  bool _isWithin14Days(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = day.difference(today).inDays;
    return diff >= 0 && diff <= 14;
  }

  @override
  Widget build(BuildContext context) {
    final slots =
        _selectedDay != null ? _getSlotsForDay(_selectedDay!) : <TimeSlotModel>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.fixedSlot),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Fixed slot info banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppDimensions.screenPadding),
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, Color(0xFF0480E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uw vaste tijdstip:',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text(
                  'Maandag om 15:00',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'De Bilt',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          // 14-day rule indicator
          _build14DayIndicator(),

          // Calendar
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalendar(),
                  const SizedBox(height: AppDimensions.md),
                  // Legend
                  _buildLegend(),
                  const SizedBox(height: AppDimensions.md),
                  // Time slots
                  if (_selectedDay != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beschikbare tijden voor ${DateFormat('EEEE d MMMM', 'nl').format(_selectedDay!)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.md),
                          if (slots.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'Geen beschikbare tijden op deze datum.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...slots.map((slot) => _buildSlotCard(slot)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedSlotId != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to booking summary
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.textWhite,
                    minimumSize:
                        const Size(double.infinity, AppDimensions.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Boek deze les',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _build14DayIndicator() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: AppColors.info),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'U kunt tot 14 dagen vooruit boeken op uw vaste tijdstip.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.screenPadding),
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
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 60)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!_isWithin14Days(selectedDay)) return;
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedSlotId = null;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 2),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.slotSelected,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: AppColors.textPrimary),
          weekendTextStyle: const TextStyle(color: AppColors.textPrimary),
          disabledTextStyle: const TextStyle(color: AppColors.slotPast),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          leftChevronIcon:
              Icon(Icons.chevron_left, color: AppColors.primaryBlue),
          rightChevronIcon:
              Icon(Icons.chevron_right, color: AppColors.primaryBlue),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          weekendStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        enabledDayPredicate: (day) => _isWithin14Days(day),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final normalized = DateTime(day.year, day.month, day.day);
            if (_availableDates.contains(normalized)) {
              return _buildDayCell(
                day.day.toString(),
                AppColors.slotAvailable,
                Colors.white,
              );
            }
            if (_fullDates.contains(normalized)) {
              return _buildDayCell(
                day.day.toString(),
                AppColors.slotFull,
                Colors.white,
              );
            }
            return null;
          },
        ),
        locale: 'nl_NL',
        startingDayOfWeek: StartingDayOfWeek.monday,
      ),
    );
  }

  Widget _buildDayCell(String text, Color bgColor, Color textColor) {
    return Center(
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(AppColors.slotAvailable, 'Beschikbaar'),
          const SizedBox(width: 20),
          _legendItem(AppColors.slotFull, 'Vol'),
          const SizedBox(width: 20),
          _legendItem(AppColors.slotSelected, 'Geselecteerd'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotCard(TimeSlotModel slot) {
    final isSelected = _selectedSlotId == slot.id;
    final isAvailable = slot.isAvailable;

    Color borderColor;
    Color bgColor;
    if (isSelected) {
      borderColor = AppColors.slotSelected;
      bgColor = AppColors.slotSelected.withValues(alpha: 0.05);
    } else if (isAvailable) {
      borderColor = AppColors.slotAvailable;
      bgColor = AppColors.white;
    } else {
      borderColor = AppColors.slotFull;
      bgColor = AppColors.slotFull.withValues(alpha: 0.03);
    }

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                _selectedSlotId = isSelected ? null : slot.id;
              });
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Time
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: isAvailable
                    ? AppColors.slotAvailable.withValues(alpha: 0.1)
                    : AppColors.slotFull.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Column(
                children: [
                  Text(
                    slot.startTime,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isAvailable
                          ? AppColors.slotAvailable
                          : AppColors.slotFull,
                    ),
                  ),
                  Text(
                    slot.endTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: isAvailable
                          ? AppColors.slotAvailable
                          : AppColors.slotFull,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.instructorName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isAvailable ? 'Beschikbaar' : 'Vol',
                    style: TextStyle(
                      fontSize: 13,
                      color: isAvailable
                          ? AppColors.slotAvailable
                          : AppColors.slotFull,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.slotSelected,
                size: 24,
              )
            else if (!isAvailable)
              const Icon(
                Icons.block,
                color: AppColors.slotFull,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
