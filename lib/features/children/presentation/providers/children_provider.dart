import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/models/child_model.dart';
import '../../data/children_service.dart';

final childrenServiceProvider = Provider<ChildrenService>(
  (ref) => ChildrenService.instance,
);

/// List of children belonging to the currently signed-in parent.
/// Refreshes automatically when auth state changes.
class MyChildrenNotifier extends StateNotifier<AsyncValue<List<ChildModel>>> {
  MyChildrenNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }

  final ChildrenService _service;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final list = await _service.fetchForCurrentParent();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addChild({
    required String firstName,
    required String lastName,
    required DateTime dob,
    String? medicalNotes,
    List<String>? allergies,
    String? emergencyContact,
    String? notes,
  }) async {
    await _service.add(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dob,
      medicalNotes: medicalNotes ?? '',
      allergies: allergies ?? const [],
      emergencyContact: emergencyContact ?? '',
      notes: notes ?? '',
    );
    await load();
  }

  Future<void> removeChild(String id) async {
    await _service.delete(id);
    await load();
  }
}

final myChildrenProvider = StateNotifierProvider<MyChildrenNotifier, AsyncValue<List<ChildModel>>>(
  (ref) => MyChildrenNotifier(ref.watch(childrenServiceProvider)),
);

/// All children in the system — for instructor views.
final allChildrenProvider = FutureProvider<List<ChildModel>>((ref) async {
  return ref.watch(childrenServiceProvider).fetchAll();
});
