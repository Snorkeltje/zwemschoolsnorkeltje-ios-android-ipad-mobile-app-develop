import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

class CancellationConfirmScreen extends StatefulWidget {
  const CancellationConfirmScreen({super.key});

  @override
  State<CancellationConfirmScreen> createState() =>
      _CancellationConfirmScreenState();
}

class _CancellationConfirmScreenState extends State<CancellationConfirmScreen> {
  bool _confirmed = false;
  bool _showSuccess = false;

  // -- Colors --
  static const _bg = Color(0xFFF4F7FC);
  static const _dark = Color(0xFF131827);
  static const _subtitle = Color(0xFF6B7B94);
  static const _red = Color(0xFFE74C3C);
  static const _redBg = Color(0xFFFDE8E8);
  static const _blue = Color(0xFF0365C4);
  static const _blueBg = Color(0xFFE8F4FD);
  static const _greenBg = Color(0xFFE8F8F0);
  static const _green = Color(0xFF27AE60);
  static const _warningBg = Color(0xFFFEF3DC);
  static const _warningText = Color(0xFF92690A);
  static const _disabledGrey = Color(0xFFA0AEC0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _showSuccess ? _buildSuccessView() : _buildConfirmView(),
    );
  }

  // ───────────────────────────────────────────────
  // CONFIRM VIEW
  // ───────────────────────────────────────────────
  Widget _buildConfirmView() {
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => smartBack(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.chevron_left, color: _dark, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Annulering bevestigen',
                style: TextStyle(
                  color: _dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning card
                _buildWarningCard(),
                const SizedBox(height: 16),

                // Booking details card
                _buildBookingDetailsCard(),
                const SizedBox(height: 16),

                // Refund card
                _buildRefundCard(),
                const SizedBox(height: 16),

                // Cancellation policy banner
                _buildPolicyBanner(),
                const SizedBox(height: 20),

                // Checkbox row
                _buildCheckboxRow(),
                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _redBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Let op!',
                  style: TextStyle(
                    color: _red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'U staat op het punt deze les te annuleren. '
                  'Deze actie kan niet ongedaan worden gemaakt.',
                  style: TextStyle(
                    color: _red.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lesgegevens',
            style: TextStyle(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _detailRow(Icons.confirmation_number_outlined,
              '#232508 — 1-op-2 zwemles'),
          const SizedBox(height: 12),
          _detailRow(Icons.access_time_rounded,
              'Woensdag 22 april 2026, 16:00 – 16:30'),
          const SizedBox(height: 12),
          _detailRow(Icons.location_on_outlined, 'De Bilt'),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _blueBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _blue, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _dark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefundCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Terugbetaling',
            style: TextStyle(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _greenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.credit_card_rounded,
                    color: _green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tegoed wordt teruggestort',
                        style: TextStyle(
                          color: _green,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '€39 wordt automatisch teruggestort op uw saldo',
                        style: TextStyle(
                          color: _subtitle,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.access_time_rounded, color: _warningText, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Annulering is kosteloos tot 24 uur voor aanvang. '
              'Bij annulering binnen 24 uur wordt het tegoed niet teruggestort. '
              'Voor vaste lessen geldt een opzegtermijn van 96 uur.',
              style: TextStyle(
                color: _warningText,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow() {
    return GestureDetector(
      onTap: () => setState(() => _confirmed = !_confirmed),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _confirmed ? _red : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _confirmed ? _red : const Color(0xFFCBD5E0),
                width: 1.5,
              ),
            ),
            child: _confirmed
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Ik begrijp dat deze actie niet ongedaan kan worden gemaakt',
              style: TextStyle(
                color: _dark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => smartBack(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E0)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Terug',
              style: TextStyle(
                color: _dark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _confirmed
                ? () => setState(() => _showSuccess = true)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _confirmed ? _red : _disabledGrey,
              disabledBackgroundColor: _disabledGrey,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Annuleer les',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // SUCCESS VIEW
  // ───────────────────────────────────────────────
  Widget _buildSuccessView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Green circle with check
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: _greenBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: _green, size: 44),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Les geannuleerd',
              style: TextStyle(
                color: _dark,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // Refund card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    '€39 teruggestort',
                    style: TextStyle(
                      color: _green,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Teruggestort op uw tegoed',
                    style: TextStyle(
                      color: _subtitle,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // Blue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    context.goNamed(RouteNames.myReservations),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Naar mijn reserveringen',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Text button
            TextButton(
              onPressed: () => context.goNamed(RouteNames.home),
              child: const Text(
                'Ga naar home',
                style: TextStyle(
                  color: _subtitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
