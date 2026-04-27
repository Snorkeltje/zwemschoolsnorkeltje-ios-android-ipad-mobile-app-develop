import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/reservations_repository.dart';

final reservationsRepoProvider = Provider<ReservationsRepository>(
  (_) => ReservationsRepository(Supabase.instance.client),
);

final myReservationsProvider = FutureProvider<List<ReservationItem>>((ref) async {
  final id = Supabase.instance.client.auth.currentUser?.id;
  if (id == null) return const [];
  return ref.read(reservationsRepoProvider).fetchForParent(id);
});

final instructorReservationsProvider = FutureProvider<List<ReservationItem>>((ref) async {
  final id = Supabase.instance.client.auth.currentUser?.id;
  if (id == null) return const [];
  return ref.read(reservationsRepoProvider).fetchForInstructor(id);
});
