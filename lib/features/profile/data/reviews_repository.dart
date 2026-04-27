import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewItem {
  final String id;
  final String parentName;
  final int rating;        // 1-10
  final String text;
  final int helpfulCount;
  final String? location;
  final String? instructor;
  final String? ownerResponse;
  final bool published;
  final DateTime createdAt;

  const ReviewItem({
    required this.id,
    required this.parentName,
    required this.rating,
    required this.text,
    required this.helpfulCount,
    required this.location,
    required this.instructor,
    required this.ownerResponse,
    required this.published,
    required this.createdAt,
  });

  /// Walter rule: ratings <6 must have an owner response before going public.
  bool get isPublishable => rating >= 6 || ownerResponse != null;

  String relativeDate() {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays < 1) return 'Vandaag';
    if (diff.inDays < 7) return '${diff.inDays}d geleden';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w geleden';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} maand${diff.inDays >= 60 ? "en" : ""} geleden';
    return '${(diff.inDays / 365).floor()} jaar geleden';
  }
}

class ReviewsRepository {
  ReviewsRepository(this._client);
  final SupabaseClient _client;

  Future<List<ReviewItem>> fetchAll() async {
    final rows = await _client
        .from('reviews')
        .select('''
          id, rating, text, helpful_count, owner_response, published, created_at,
          profiles:parent_id ( first_name, last_name ),
          locations:location_id ( name ),
          instructor:instructor_id ( first_name, last_name )
        ''')
        .eq('published', true)
        .order('created_at', ascending: false);
    return rows.map<ReviewItem>(_map).toList();
  }

  Future<List<ReviewItem>> fetchForInstructor(String instructorId) async {
    final rows = await _client
        .from('reviews')
        .select('''
          id, rating, text, helpful_count, owner_response, published, created_at,
          profiles:parent_id ( first_name, last_name ),
          locations:location_id ( name ),
          instructor:instructor_id ( first_name, last_name )
        ''')
        .eq('instructor_id', instructorId)
        .eq('published', true)
        .order('created_at', ascending: false);
    return rows.map<ReviewItem>(_map).toList();
  }

  ReviewItem _map(Map<String, dynamic> r) {
    final pp = (r['profiles'] as Map?) ?? const {};
    final loc = (r['locations'] as Map?) ?? const {};
    final inst = (r['instructor'] as Map?) ?? const {};
    final parentName = '${(pp['first_name'] as String?) ?? ''} ${(pp['last_name'] as String?) ?? ''}'.trim();
    final instructorName = '${(inst['first_name'] as String?) ?? ''} ${(inst['last_name'] as String?) ?? ''}'.trim();
    return ReviewItem(
      id: r['id'] as String,
      parentName: parentName.isEmpty ? 'Anoniem' : parentName,
      rating: (r['rating'] as int?) ?? 0,
      text: (r['text'] as String?) ?? '',
      helpfulCount: (r['helpful_count'] as int?) ?? 0,
      location: loc['name'] as String?,
      instructor: instructorName.isEmpty ? null : instructorName,
      ownerResponse: r['owner_response'] as String?,
      published: (r['published'] as bool?) ?? true,
      createdAt: DateTime.parse(r['created_at'] as String),
    );
  }
}
