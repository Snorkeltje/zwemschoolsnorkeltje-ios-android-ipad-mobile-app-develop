/// Walter 2026-08-16 — Slot offer invitation screen with live 24h countdown.
///
/// Parent lands here from a push notification / email deep-link when a slot
/// opens for their child. Shows the slot details, a real-time countdown, and
/// Accept / Decline buttons that call the waitlist-claim-offer edge function.
///
/// After Accept: pushes the parent to the first-3-lessons payment flow.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/waitlist_models.dart';
import '../../data/repositories/waitlist_repository.dart';

class WaitlistInvitationScreen extends StatefulWidget {
  /// The waitlist_slot_offer.id passed via deep link.
  final String? invitationId;

  const WaitlistInvitationScreen({super.key, this.invitationId});

  @override
  State<WaitlistInvitationScreen> createState() => _WaitlistInvitationScreenState();
}

class _WaitlistInvitationScreenState extends State<WaitlistInvitationScreen> {
  final _repo = WaitlistRepository();
  SlotOffer? _offer;
  _ChildContext? _child;
  bool _loading = true;
  bool _responding = false;
  Timer? _tickTimer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    if (widget.invitationId == null) {
      setState(() => _loading = false);
      return;
    }
    final offer = await _repo.fetchOfferById(widget.invitationId!);
    if (offer == null) {
      setState(() => _loading = false);
      return;
    }
    // Also load child name via the waitlist row.
    final child = await _loadChildContext(offer.waitlistId);
    if (!mounted) return;
    setState(() {
      _offer = offer;
      _child = child;
      _remaining = offer.timeRemaining;
      _loading = false;
    });
    // Start ticking every second so the countdown stays live.
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = offer.timeRemaining;
      setState(() => _remaining = next);
      if (next == Duration.zero) _tickTimer?.cancel();
    });
  }

  Future<_ChildContext?> _loadChildContext(String waitlistId) async {
    final client = SupabaseService.client;
    if (client == null) return null;
    try {
      final row = await client
          .from('waitlist')
          .select('lesson_type, list_type, general_registration_date, '
              'children:child_id ( first_name, last_name )')
          .eq('id', waitlistId)
          .maybeSingle();
      if (row == null) return null;
      final c = row['children'] as Map?;
      return _ChildContext(
        childFirstName: (c?['first_name'] as String?) ?? '',
        childLastName: (c?['last_name'] as String?) ?? '',
        lessonType: WaitlistLessonTypeX.fromString(row['lesson_type'] as String?),
        listType: WaitlistListTypeX.fromString(
          (row['list_type'] as String?) ?? 'general',
        ),
        waitingSince: DateTime.parse(
          (row['general_registration_date'] as String?) ??
              DateTime.now().toIso8601String(),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _respond(bool accept) async {
    if (_responding || _offer == null) return;
    setState(() => _responding = true);
    final err = await _repo.respondToSlotOffer(
      offerId: _offer!.id,
      accept: accept,
    );
    if (!mounted) return;
    setState(() => _responding = false);

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('❌ $err'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (accept) {
      _showAcceptedDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Uitnodiging afgewezen — de plek gaat naar de volgende.'),
      ));
      if (mounted) context.pop();
    }
  }

  void _showAcceptedDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.celebration, color: AppColors.success, size: 28),
            SizedBox(width: 8),
            Text('Gefeliciteerd!'),
          ],
        ),
        content: const Text(
          'De plek is nu van uw kind. Nog één stap: reserveer en betaal de '
          'eerste 3 lessen om de plek definitief te maken.\n\n'
          'Zonder betaling binnen 24 uur vervalt de plek weer naar de wachtlijst.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (mounted) context.pop();
            },
            child: const Text('Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: navigate to /waitlist-first-three-lessons?waitlistId=...
              if (mounted) {
                context.go(
                  '/waitlist-first-three?waitlistId=${_offer!.waitlistId}',
                );
              }
            },
            child: const Text('Betaal 3 lessen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Uitnodiging'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offer == null
              ? _buildNotFound()
              : _buildContent(),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'Uitnodiging niet gevonden',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Deze uitnodiging bestaat niet meer of is al beantwoord.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Terug'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final offer = _offer!;
    final child = _child;
    final expired = _remaining == Duration.zero;
    final urgent = _remaining.inHours < 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        children: [
          // Countdown banner
          _buildCountdown(expired: expired, urgent: urgent),
          const SizedBox(height: 16),

          // Invitation card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.sectionSpacing),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: AppDimensions.shadowBlur,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.celebration, color: AppColors.success, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Er is een plek vrij!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Goed nieuws! Er is een plek vrijgekomen voor '
                  '${child?.childFirstName ?? "uw kind"} bij Zwemschool Snorkeltje.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: AppDimensions.sectionSpacing),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 16),

                _buildDetailRow(
                  Icons.child_care_outlined, 'Kind',
                  '${child?.childFirstName ?? ""} ${child?.childLastName ?? ""}'.trim(),
                ),
                _buildDetailRow(Icons.location_on_outlined, 'Locatie', offer.locationName),
                _buildDetailRow(
                  Icons.calendar_today_outlined, 'Dag',
                  '${offer.dayLabel} ${offer.slotTime.substring(0, 5)}',
                ),
                _buildDetailRow(
                  Icons.pool_outlined, 'Lestype',
                  child?.lessonType.label ?? 'Zwemles',
                ),
                _buildDetailRow(
                  Icons.emoji_events_outlined,
                  'Uw wachtpositie',
                  '#${offer.priorityRank}',
                ),
                if (child != null)
                  _buildDetailRow(
                    Icons.hourglass_bottom_outlined, 'Wacht sinds',
                    _formatDate(child.waitingSince),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBFDBFE)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline, color: Color(0xFF1E40AF), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Als u accepteert, moet u binnen 24 uur de eerste 3 lessen '
                    'reserveren en betalen om de plek definitief te maken. '
                    'Anders vervalt de plek weer.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          if (!expired) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _responding ? null : () => _respond(true),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _responding
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        '✓ Accepteer de plek',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _responding ? null : () => _respond(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Afwijzen',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                border: Border.all(color: const Color(0xFFFECACA)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.timer_off_outlined, color: Color(0xFF991B1B), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Deze uitnodiging is verlopen. De plek is naar de '
                      'volgende ouder op de wachtlijst gegaan.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
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

  Widget _buildCountdown({required bool expired, required bool urgent}) {
    final bg = expired
        ? const Color(0xFFFEF2F2)
        : urgent
            ? const Color(0xFFFFF7ED)
            : const Color(0xFFECFDF5);
    final fg = expired
        ? const Color(0xFF991B1B)
        : urgent
            ? const Color(0xFF9A3412)
            : const Color(0xFF065F46);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            expired
                ? 'Deze uitnodiging is verlopen'
                : 'U heeft nog',
            style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          if (!expired)
            Text(
              _formatDuration(_remaining),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }

  static Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _formatDate(DateTime dt) {
    const months = <String>[
      'jan', 'feb', 'mrt', 'apr', 'mei', 'jun',
      'jul', 'aug', 'sep', 'okt', 'nov', 'dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

class _ChildContext {
  final String childFirstName;
  final String childLastName;
  final WaitlistLessonType lessonType;
  final WaitlistListType listType;
  final DateTime waitingSince;
  const _ChildContext({
    required this.childFirstName,
    required this.childLastName,
    required this.lessonType,
    required this.listType,
    required this.waitingSince,
  });
}
