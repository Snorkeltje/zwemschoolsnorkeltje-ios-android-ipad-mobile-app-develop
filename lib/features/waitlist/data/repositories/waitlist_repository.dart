/// Walter 2026-05-07 — Phase 2 waitlist repository.
/// Handles all Supabase queries for the waiting list system:
/// registration, position viewing, slot offers, acceptance flow.
library;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/waitlist_models.dart';

class WaitlistRepository {
  WaitlistRepository();

  SupabaseClient? get _client => SupabaseService.client;

  /// All locations with their Mini Survival support flag.
  Future<List<WaitlistLocation>> fetchLocations() async {
    final client = _client;
    if (client == null) return [];
    try {
      final rows = await client
          .from('locations')
          .select('id, name, city, supports_mini_survival, active')
          .eq('active', true)
          .order('name');
      return (rows as List)
          .map((r) => WaitlistLocation.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ fetchLocations failed: $e');
      return const [];
    }
  }

  /// Current waitlist entries for the logged-in parent (all list types).
  Future<List<WaitlistEntry>> fetchMyEntries() async {
    final client = _client;
    if (client == null) return [];
    final uid = client.auth.currentUser?.id;
    if (uid == null) return [];
    try {
      final rows = await client
          .from('waitlist')
          .select()
          .eq('parent_id', uid)
          .order('general_registration_date', ascending: true);
      return (rows as List)
          .map((r) => WaitlistEntry.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ fetchMyEntries failed: $e');
      return const [];
    }
  }

  /// Per-slot ranking — for every (location, day, time) the parent expressed
  /// interest in, compute their rank within all confirmed entries also
  /// expressing interest in that same slot.
  ///
  /// Sorted by general_registration_date ASC (longest-waiting = position 1).
  Future<List<SlotPosition>> fetchMyPositionsPerSlot() async {
    final client = _client;
    if (client == null) return [];
    final uid = client.auth.currentUser?.id;
    if (uid == null) return [];

    try {
      // 1. Get my waitlist entries (all list types, confirmed)
      final myRows = await client
          .from('waitlist')
          .select(
            'id, list_type, preferred_location_ids, availability_grid, '
            'general_registration_date',
          )
          .eq('parent_id', uid)
          .eq('confirmation_status', 'confirmed');

      if ((myRows as List).isEmpty) return [];

      // 2. Get all confirmed entries (we'll rank against them)
      final allRows = await client
          .from('waitlist')
          .select(
            'parent_id, list_type, preferred_location_ids, '
            'availability_grid, general_registration_date',
          )
          .eq('confirmation_status', 'confirmed')
          .order('general_registration_date', ascending: true);

      // 3. Locations lookup
      final locsRows = await client.from('locations').select('id, name');
      final locsById = {
        for (final l in (locsRows as List))
          l['id'] as String: l['name'] as String? ?? '—'
      };

      // 4. For each of my entries, enumerate the (location × day × time) combos
      //    in my availability grid and rank vs. everyone else with that combo.
      final results = <SlotPosition>[];

      for (final myRow in myRows as List) {
        final myId = myRow['id'] as String;
        final myListType = WaitlistListTypeX.fromString(
          (myRow['list_type'] as String?) ?? 'general',
        );
        final myLocs = ((myRow['preferred_location_ids'] as List?) ?? const [])
            .cast<String>();
        final myAvail = AvailabilityGrid.fromJson(myRow['availability_grid']);
        final myDate = DateTime.parse(
          (myRow['general_registration_date'] as String?) ??
              DateTime.now().toIso8601String(),
        );

        for (final locId in myLocs) {
          final locName = locsById[locId] ?? '—';
          // Iterate weekdays
          for (final entry in myAvail.blocks.entries) {
            final dayName = entry.key;
            final dayIdx = _dayIndex(dayName);
            if (dayIdx == 0) continue;
            for (final block in entry.value) {
              if (block.length != 2) continue;
              // Use the block start time as the slot anchor.
              final time = block[0];

              // Count how many OTHER entries also include this slot AND have
              // an earlier general_registration_date than mine.
              int earlierCount = 0;
              int totalCount = 0;
              for (final otherRow in allRows as List) {
                final otherListType = WaitlistListTypeX.fromString(
                  (otherRow['list_type'] as String?) ?? 'general',
                );
                if (otherListType != myListType) continue;
                final otherLocs = ((otherRow['preferred_location_ids'] as List?) ??
                        const [])
                    .cast<String>();
                if (!otherLocs.contains(locId)) continue;
                final otherAvail = AvailabilityGrid.fromJson(
                  otherRow['availability_grid'],
                );
                if (!otherAvail.isAvailable(dayName, time)) continue;
                totalCount++;
                final otherDate = DateTime.parse(
                  (otherRow['general_registration_date'] as String?) ??
                      DateTime.now().toIso8601String(),
                );
                if (otherDate.isBefore(myDate)) {
                  earlierCount++;
                }
              }

              results.add(SlotPosition(
                locationId: locId,
                locationName: locName,
                dayOfWeek: dayIdx,
                timeSlot: time,
                position: earlierCount + 1, // me + everyone earlier
                totalWaiting: totalCount,
                listType: myListType,
              ));
            }
          }
        }
        // Reference myId so the compiler keeps the read warning silent.
        // (myId may be useful for future deep linking from results.)
        results.length; // no-op to keep myId scoped
        myId;
      }

      // Sort: list_type then location then day then time
      results.sort((a, b) {
        final t = a.listType.index.compareTo(b.listType.index);
        if (t != 0) return t;
        final l = a.locationName.compareTo(b.locationName);
        if (l != 0) return l;
        final d = a.dayOfWeek.compareTo(b.dayOfWeek);
        if (d != 0) return d;
        return a.timeSlot.compareTo(b.timeSlot);
      });
      return results;
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ fetchMyPositionsPerSlot failed: $e');
      return const [];
    }
  }

  /// Active slot offers waiting for the parent's response (24h window).
  Future<List<SlotOffer>> fetchMyPendingOffers() async {
    final client = _client;
    if (client == null) return [];
    final uid = client.auth.currentUser?.id;
    if (uid == null) return [];
    try {
      final rows = await client
          .from('waitlist_slot_offers')
          .select(
            'id, waitlist_id, location_id, day_of_week, slot_time, '
            'offered_at, expires_at, response, priority_rank, '
            'locations:location_id ( name ), '
            'waitlist:waitlist_id!inner ( parent_id )',
          )
          .eq('waitlist.parent_id', uid)
          .eq('response', 'pending')
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('expires_at', ascending: true);
      return (rows as List)
          .map((r) => SlotOffer.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ fetchMyPendingOffers failed: $e');
      return const [];
    }
  }

  /// Register the parent's child on a waitlist.
  Future<WaitlistEntry?> register({
    required String childId,
    required WaitlistListType listType,
    required List<String> locationIds,
    required WaitlistLessonType lessonType,
    required AvailabilityGrid availability,
    int? waterFreeRating,
    String? comment,
  }) async {
    final client = _client;
    if (client == null) return null;
    final uid = client.auth.currentUser?.id;
    if (uid == null) return null;
    try {
      final now = DateTime.now().toIso8601String();
      final inserted = await client
          .from('waitlist')
          .insert({
            'parent_id': uid,
            'child_id': childId,
            'list_type': listType.value,
            'preferred_location_ids': locationIds,
            'lesson_type': lessonType.value,
            'availability_grid': availability.toJson(),
            'water_free_rating': waterFreeRating,
            'general_registration_date': now,
            'official_registration_date':
                listType == WaitlistListType.official ? now : null,
            'confirmation_status': 'confirmed',
            'status': 'active',
            'comment': comment,
          })
          .select()
          .single();
      return WaitlistEntry.fromJson(Map<String, dynamic>.from(inserted));
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ waitlist register failed: $e');
      return null;
    }
  }

  /// Upgrade a general-list entry to the official list (parent paid €30).
  Future<bool> upgradeToOfficial({
    required String waitlistId,
    required String stripePaymentIntentId,
  }) async {
    final client = _client;
    if (client == null) return false;
    try {
      await client.from('waitlist').update({
        'list_type': 'official',
        'official_registration_date': DateTime.now().toIso8601String(),
        'registration_fee_paid': true,
        'registration_fee_stripe_intent_id': stripePaymentIntentId,
        'status': 'active',
      }).eq('id', waitlistId);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ upgradeToOfficial failed: $e');
      return false;
    }
  }

  /// Respond to a slot offer via the edge function so the race-protection
  /// logic runs (locks the row, cancels sibling offers, notifies losers).
  /// Returns null on success, error string on failure.
  Future<String?> respondToSlotOffer({
    required String offerId,
    required bool accept,
  }) async {
    final client = _client;
    if (client == null) return 'Niet ingelogd';
    try {
      final res = await client.functions.invoke('waitlist-claim-offer', body: {
        'offer_id': offerId,
        'action': accept ? 'accept' : 'decline',
      });
      final data = res.data as Map<String, dynamic>?;
      if (data?['ok'] == true) return null;
      return (data?['error'] as String?) ?? 'Onbekende fout';
    } catch (e) {
      return e.toString();
    }
  }

  /// Update the parent's own availability grid + preferences.
  Future<bool> updateMyAvailability({
    required String waitlistId,
    required AvailabilityGrid grid,
    int? waterFreeRating,
    WaitlistLessonType? lessonType,
  }) async {
    final client = _client;
    if (client == null) return false;
    try {
      final patch = <String, dynamic>{
        'availability_grid': grid.toJson(),
      };
      if (waterFreeRating != null) patch['water_free_rating'] = waterFreeRating;
      if (lessonType != null) patch['lesson_type'] = lessonType.value;
      await client.from('waitlist').update(patch).eq('id', waitlistId);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ updateMyAvailability failed: $e');
      return false;
    }
  }

  /// Confirm a migration entry — parent clicked the unique link in the
  /// migration email. Activates their spot and preserves original date.
  Future<bool> confirmMigration({required String confirmationToken}) async {
    final client = _client;
    if (client == null) return false;
    try {
      final res = await client.functions.invoke('waitlist-confirm-migration', body: {
        'confirmation_token': confirmationToken,
      });
      final data = res.data as Map<String, dynamic>?;
      return data?['ok'] == true;
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ confirmMigration failed: $e');
      return false;
    }
  }

  /// Load a single offer by id (needed when parent opens the invitation
  /// screen via deep link from a push notification).
  Future<SlotOffer?> fetchOfferById(String offerId) async {
    final client = _client;
    if (client == null) return null;
    try {
      final row = await client
          .from('waitlist_slot_offers')
          .select(
            'id, waitlist_id, location_id, day_of_week, slot_time, '
            'offered_at, expires_at, response, priority_rank, '
            'locations:location_id ( name )',
          )
          .eq('id', offerId)
          .maybeSingle();
      if (row == null) return null;
      return SlotOffer.fromJson(Map<String, dynamic>.from(row));
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ fetchOfferById failed: $e');
      return null;
    }
  }

  /// Compute a parent's age bracket for the current child. Used by the
  /// join-flow screen to route between General List (under 4) and Official
  /// List (4+).
  static bool isUnderFour(DateTime dateOfBirth) {
    final now = DateTime.now();
    final fourthBirthday = DateTime(
      dateOfBirth.year + 4,
      dateOfBirth.month,
      dateOfBirth.day,
    );
    return now.isBefore(fourthBirthday);
  }

  static int _dayIndex(String name) => switch (name.toLowerCase()) {
        'monday' || 'maandag' => 1,
        'tuesday' || 'dinsdag' => 2,
        'wednesday' || 'woensdag' => 3,
        'thursday' || 'donderdag' => 4,
        'friday' || 'vrijdag' => 5,
        'saturday' || 'zaterdag' => 6,
        'sunday' || 'zondag' => 7,
        _ => 0,
      };
}
