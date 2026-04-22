import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

class FixedSlotCalendarScreen extends StatefulWidget {
  const FixedSlotCalendarScreen({super.key});

  @override
  State<FixedSlotCalendarScreen> createState() =>
      _FixedSlotCalendarScreenState();
}

class _FixedSlotCalendarScreenState extends State<FixedSlotCalendarScreen> {
  // Current displayed month
  int _displayMonth = 4; // April
  int _displayYear = 2026;

  // Selected day (null = none)
  int? _selectedDay;

  // Mock data: available days (green), full days (red)
  final Set<int> _availableDays = {7, 14, 21, 28}; // Mondays in April 2026
  final Set<int> _fullDays = {8, 15, 22};

  static const List<String> _dayHeaders = [
    'Ma',
    'Di',
    'Wo',
    'Do',
    'Vr',
    'Za',
    'Zo'
  ];

  static const List<String> _monthNames = [
    'januari',
    'februari',
    'maart',
    'april',
    'mei',
    'juni',
    'juli',
    'augustus',
    'september',
    'oktober',
    'november',
    'december',
  ];

  static const List<String> _dayNames = [
    'Maandag',
    'Dinsdag',
    'Woensdag',
    'Donderdag',
    'Vrijdag',
    'Zaterdag',
    'Zondag',
  ];

  String get _monthLabel =>
      '${_monthNames[_displayMonth - 1]} $_displayYear';

  void _prevMonth() {
    setState(() {
      if (_displayMonth == 1) {
        _displayMonth = 12;
        _displayYear--;
      } else {
        _displayMonth--;
      }
      _selectedDay = null;
    });
  }

  void _nextMonth() {
    setState(() {
      if (_displayMonth == 12) {
        _displayMonth = 1;
        _displayYear++;
      } else {
        _displayMonth++;
      }
      _selectedDay = null;
    });
  }

  /// Returns the weekday index (0=Mon, 6=Sun) for the 1st of the displayed month.
  int get _firstWeekday {
    final d = DateTime(_displayYear, _displayMonth, 1);
    return d.weekday - 1; // DateTime: 1=Mon => 0
  }

  int get _daysInMonth {
    return DateTime(_displayYear, _displayMonth + 1, 0).day;
  }

  String _selectedDateLabel() {
    if (_selectedDay == null) return '';
    final d = DateTime(_displayYear, _displayMonth, _selectedDay!);
    final dayName = _dayNames[d.weekday - 1];
    return '$dayName, $_selectedDay ${_monthNames[_displayMonth - 1]} $_displayYear';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildGradientHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Overlapping fixed slot info card
                  Transform.translate(
                    offset: const Offset(0, -14),
                    child: _buildFixedSlotInfoCard(),
                  ),
                  // Calendar card
                  _buildCalendarCard(),
                  const SizedBox(height: 16),
                  _buildLegend(),
                  const SizedBox(height: 16),
                  // Selected date details
                  if (_selectedDay != null) _buildSelectedDateDetails(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedDay != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: _buildBookButton(context),
              ),
            )
          : null,
    );
  }

  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => smartBack(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vast Tijdstip',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selecteer een datum',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedSlotInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gradient clock icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Maandag 15:00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'De Bilt Zwembad \u00B7 Wekelijks',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Month header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0365C4), Color(0xFF034DA9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _prevMonth,
                    child: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 28),
                  ),
                  Text(
                    _monthLabel[0].toUpperCase() + _monthLabel.substring(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: const Icon(Icons.chevron_right,
                        color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            // Day of week headers
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _dayHeaders
                    .map((d) => SizedBox(
                          width: 38,
                          child: Center(
                            child: Text(
                              d,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            // Calendar grid
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
              child: _buildCalendarGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final totalCells = _firstWeekday + _daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              final day = index - _firstWeekday + 1;

              if (day < 1 || day > _daysInMonth) {
                return const SizedBox(width: 38, height: 38);
              }

              final isSelected = _selectedDay == day;
              final isAvailable = _availableDays.contains(day);
              final isFull = _fullDays.contains(day);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                  });
                },
                child: _buildDayCell(day, isSelected, isAvailable, isFull),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(int day, bool isSelected, bool isAvailable, bool isFull) {
    BoxDecoration decoration;
    TextStyle textStyle;

    if (isSelected) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0365C4).withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
      textStyle = const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
    } else if (isAvailable) {
      decoration = BoxDecoration(
        color: const Color(0xFFE8F8F0),
        borderRadius: BorderRadius.circular(12),
      );
      textStyle = const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF27AE60),
      );
    } else if (isFull) {
      decoration = BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(12),
      );
      textStyle = const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE74C3C),
      );
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      );
      textStyle = const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );
    }

    return Container(
      width: 38,
      height: 38,
      decoration: decoration,
      alignment: Alignment.center,
      child: Text(day.toString(), style: textStyle),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(const Color(0xFFE8F8F0), const Color(0xFF27AE60), 'Beschikbaar'),
          const SizedBox(width: 20),
          _legendItem(null, const Color(0xFF0365C4), 'Geselecteerd', isGradient: true),
          const SizedBox(width: 20),
          _legendItem(const Color(0xFFFDE8E8), const Color(0xFFE74C3C), 'Vol'),
        ],
      ),
    );
  }

  Widget _legendItem(Color? bgColor, Color textColor, String label,
      {bool isGradient = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isGradient ? null : bgColor ?? textColor,
            gradient: isGradient
                ? const LinearGradient(
                    colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])
                : null,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSelectedDateDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date title with blue dot
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0365C4),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDateLabel(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Detail rows
            _buildDetailRow(
              Icons.access_time,
              const Color(0xFF0365C4),
              '15:00 \u2013 15:30 (30 min)',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.location_on_outlined,
              const Color(0xFFFF5C00),
              'De Bilt Zwembad',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.person_outline,
              const Color(0xFF27AE60),
              'Jan de Vries',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteNames.bookingSummary);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0365C4).withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Deze les boeken \u2192',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
