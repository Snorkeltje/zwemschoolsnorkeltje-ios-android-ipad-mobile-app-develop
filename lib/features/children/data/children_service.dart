import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../auth/data/models/child_model.dart';

/// Children CRUD backed by Supabase `children` table.
/// RLS: parent sees own children, instructor/admin sees all.
class ChildrenService {
  ChildrenService._();
  static final ChildrenService instance = ChildrenService._();

  SupabaseClient? get _client => SupabaseService.client;

  /// List children for the current authenticated user (parent).
  Future<List<ChildModel>> fetchForCurrentParent() async {
    final c = _client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) return [];
    final rows = await c.from('children').select().eq('parent_id', uid).order('created_at');
    return rows.map<ChildModel>((r) => _rowToModel(r)).toList();
  }

  /// List all children (for instructors — they need to see students' medical info).
  Future<List<ChildModel>> fetchAll() async {
    final c = _client;
    if (c == null) return [];
    final rows = await c.from('children').select().order('first_name');
    return rows.map<ChildModel>((r) => _rowToModel(r)).toList();
  }

  /// Create a new child under current parent.
  Future<ChildModel?> add({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    String level = 'Beginner',
    String medicalNotes = '',
    List<String> allergies = const [],
    String emergencyContact = '',
    String notes = '',
  }) async {
    final c = _client;
    final uid = c?.auth.currentUser?.id;
    if (c == null || uid == null) return null;

    final row = await c.from('children').insert({
      'parent_id': uid,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': '${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}',
      'level': level,
      'medical_notes': medicalNotes,
      'allergies': allergies,
      'emergency_contact': emergencyContact,
      'notes': notes,
    }).select().single();

    return _rowToModel(row);
  }

  Future<void> update(String id, Map<String, dynamic> patch) async {
    final c = _client;
    if (c == null) return;
    await c.from('children').update(patch).eq('id', id);
  }

  Future<void> delete(String id) async {
    final c = _client;
    if (c == null) return;
    await c.from('children').delete().eq('id', id);
  }

  ChildModel _rowToModel(Map<String, dynamic> r) {
    final firstName = r['first_name'] as String? ?? '';
    final lastName = r['last_name'] as String? ?? '';
    final full = [firstName, lastName].where((s) => s.isNotEmpty).join(' ').trim();
    return ChildModel(
      id: r['id'] as String,
      name: full.isEmpty ? 'Kind' : full,
      dateOfBirth: DateTime.tryParse(r['date_of_birth'] as String? ?? '') ?? DateTime.now(),
      currentLevel: r['level'] as String? ?? 'Beginner',
      profileImage: null,
    );
  }
}
