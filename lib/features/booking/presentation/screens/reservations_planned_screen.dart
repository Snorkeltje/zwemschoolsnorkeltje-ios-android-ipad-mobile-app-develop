import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/smart_back.dart';

class ReservationsPlannedScreen extends StatelessWidget {
  const ReservationsPlannedScreen({super.key});

  static const Color _accentBlue = Color(0xFF5492B5);
  static const Color _tableHeaderBg = Color(0xFFDBE6F0);
  static const Color _infoBg = Color(0xFFE8F4FC);
  static const Color _breadcrumbBg = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF334155)),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.pool, color: _accentBlue, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Zwemschool Snorkeltje',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            // Breadcrumb
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: _breadcrumbBg,
              child: const Text(
                '/ Mijn Reserveringen',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mijn Reserveringen - Gepland',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cancellation info box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _infoBg,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        border: Border.all(color: const Color(0xFFB8D8EA), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: _accentBlue),
                              SizedBox(width: 8),
                              Text(
                                'Annuleringsbeleid',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Annuleren is mogelijk tot 24 uur voor aanvang van de les. '
                            'Bij te laat annuleren wordt de les in rekening gebracht.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Could open email client
                            },
                            child: const Text(
                              'info@snorkeltje.nl',
                              style: TextStyle(
                                fontSize: 13,
                                color: _accentBlue,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: _accentBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tabs
                    Row(
                      children: [
                        // Gepland tab (active)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: _accentBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Gepland',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Geschiedenis tab
                        GestureDetector(
                          onTap: () {
                            // Navigate to history
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Geschiedenis',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, size: 14, color: Color(0xFF64748B)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Table
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            color: _tableHeaderBg,
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 72,
                                  child: Text(
                                    'Reservering ID',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Product',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 48,
                                  child: Text(
                                    'Vanaf',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 44,
                                  child: Text(
                                    'Vanaf tijd',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    'Tot tijd',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 56,
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Row 1
                          _buildReservationRow(
                            id: '#232508',
                            product: 'DE BILT 1-op-2 wo 16:00',
                            date: '22 apr',
                            startTime: '16:00',
                            endTime: '16:30',
                            status: 'Gepland',
                          ),

                          const Divider(height: 1, color: Color(0xFFE2E8F0)),

                          // Row 2
                          _buildReservationRow(
                            id: '#232507',
                            product: 'BadHulck 1-op-1 di 16:00',
                            date: '26 mei',
                            startTime: '16:00',
                            endTime: '16:30',
                            status: 'Gepland',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // History button
                    SizedBox(
                      width: double.infinity,
                      height: AppDimensions.buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to history
                        },
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text(
                          'Bekijk Geschiedenis',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationRow({
    required String id,
    required String product,
    required String date,
    required String startTime,
    required String endTime,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              id,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _accentBlue,
              ),
            ),
          ),
          Expanded(
            child: Text(
              product,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              startTime,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              endTime,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
