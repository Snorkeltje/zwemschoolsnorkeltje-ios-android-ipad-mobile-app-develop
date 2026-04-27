import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/reviews_repository.dart';

final reviewsRepoProvider = Provider<ReviewsRepository>(
  (_) => ReviewsRepository(Supabase.instance.client),
);

final allReviewsProvider = FutureProvider<List<ReviewItem>>(
  (ref) => ref.read(reviewsRepoProvider).fetchAll(),
);
