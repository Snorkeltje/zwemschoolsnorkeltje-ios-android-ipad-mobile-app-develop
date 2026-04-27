import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/reviews_repository.dart';
import '../providers/reviews_provider.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  static const _orange = Color(0xFFFF5C00);
  static const _amber = Color(0xFFF5A623);
  static const _blue = Color(0xFF0365C4);
  static const _lightBlue = Color(0xFF00C1FF);
  static const _green = Color(0xFF27AE60);
  static const _bg = Color(0xFFF4F7FC);
  static const _textPrimary = Color(0xFF1A1A2E);
  static const _textSecondary = Color(0xFF8E9BB3);
  static const _textBody = Color(0xFF4A5568);
  static const _divider = Color(0xFFF0F4FA);

  String _filter = 'Alle';
  String _instructorFilter = 'Alle instructeurs'; // Walter: per-instructor view

  /// Live reviews list (Supabase-backed, refreshed via provider).
  List<ReviewItem> get _reviews =>
      ref.watch(allReviewsProvider).value ?? const [];

  /// Walter: reviews <6 without response are NOT shown publicly
  List<ReviewItem> get _publishable => _reviews.where((r) => r.isPublishable).toList();

  /// Unique instructor names for the per-instructor filter
  List<String> get _instructorNames {
    final set = <String>{};
    for (final r in _publishable) {
      if (r.instructor != null && r.instructor!.isNotEmpty) {
        set.add(r.instructor!);
      }
    }
    final list = set.toList()..sort();
    return ['Alle instructeurs', ...list];
  }

  List<ReviewItem> get _filtered {
    var list = _publishable;
    if (_instructorFilter != 'Alle instructeurs') {
      list = list.where((r) => r.instructor == _instructorFilter).toList();
    }
    if (_filter != 'Alle') {
      final score = int.parse(_filter);
      list = list.where((r) => r.rating == score).toList();
    }
    return list;
  }

  /// Average rating for currently selected instructor scope
  double get _avg {
    final scope = _instructorFilter == 'Alle instructeurs'
        ? _publishable
        : _publishable.where((r) => r.instructor == _instructorFilter).toList();
    if (scope.isEmpty) return 0;
    return scope.fold<int>(0, (a, r) => a + r.rating) / scope.length;
  }

  int _countByRating(int rating) {
    final scope = _instructorFilter == 'Alle instructeurs'
        ? _publishable
        : _publishable.where((r) => r.instructor == _instructorFilter).toList();
    return scope.where((r) => r.rating == rating).length;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, topPadding),
            _buildInstructorFilter(),
            _buildStatsCard(),
            const SizedBox(height: 20),
            _buildFilters(),
            const SizedBox(height: 12),
            _buildReviewsList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 12,
        left: 20,
        right: 20,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_orange, _amber],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => smartBack(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Reviews',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Wat ouders zeggen',
            style: TextStyle(
                fontSize: 13, color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    _avg.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (i) => const Icon(Icons.star,
                          color: Color(0xFFFFD700), size: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${_reviews.length} reviews',
                      style: const TextStyle(
                          fontSize: 11, color: _textSecondary)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _ratingBar(10, _countByRating(10)),
                    const SizedBox(height: 6),
                    _ratingBar(9, _countByRating(9)),
                    const SizedBox(height: 6),
                    _ratingBar(8, _countByRating(8)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBar(int score, int count) {
    final pct = count / _reviews.length;
    return Row(
      children: [
        SizedBox(
          width: 18,
          child: Text(
            '$score',
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: _textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: _divider,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(colors: [_orange, _amber]),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 18,
          child: Text('$count',
              style: const TextStyle(fontSize: 11, color: _textSecondary)),
        ),
      ],
    );
  }

  Widget _buildInstructorFilter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(4),
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _instructorNames.map((name) {
          final isSelected = _instructorFilter == name;
          return GestureDetector(
            onTap: () => setState(() => _instructorFilter = name),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(colors: [_orange, _amber])
                    : null,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    name == 'Alle instructeurs' ? Icons.groups : Icons.person,
                    size: 13,
                    color: isSelected ? Colors.white : _textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['Alle', '10', '9', '8'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: _textSecondary, size: 16),
          const SizedBox(width: 8),
          ...filters.map((f) {
            final isSelected = _filter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(colors: [_blue, _lightBlue])
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? _blue.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: isSelected ? 12 : 4,
                        offset: Offset(0, isSelected ? 4 : 1),
                      ),
                    ],
                  ),
                  child: Text(
                    f == 'Alle' ? 'Alle' : '$f/10',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : _textBody,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    final items = _filtered;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: items
            .map((review) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildReviewCard(review),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildReviewCard(ReviewItem review) {
    final isHighRating = review.rating >= 9;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [_blue, _lightBlue]),
                ),
                alignment: Alignment.center,
                child: Text(
                  review.parentName[0],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.parentName,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary)),
                    Row(
                      children: [
                        Text(review.location ?? '',
                            style: const TextStyle(fontSize: 10, color: _textSecondary)),
                        const Text('  ·  ',
                            style: TextStyle(fontSize: 10, color: Color(0xFFC4CDD9))),
                        Text(review.relativeDate(),
                            style: const TextStyle(fontSize: 10, color: _textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Instructor name — Walter's feedback: per-instructor attribution
                    Row(
                      children: [
                        const Icon(Icons.person, size: 10, color: _blue),
                        const SizedBox(width: 3),
                        Text(review.instructor ?? 'Snorkeltje',
                            style: const TextStyle(fontSize: 10, color: _blue, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isHighRating
                      ? const Color(0xFFE8F8F0)
                      : const Color(0xFFFEF0E7),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${review.rating}/10',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isHighRating ? _green : _orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.text,
            style: const TextStyle(
                fontSize: 13, color: _textBody, height: 1.5),
          ),
          // Owner response (Walter: shown alongside lower-rated reviews)
          if (review.ownerResponse != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _blue.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: _blue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text('W',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      const Text('Reactie van Snorkeltje',
                          style: TextStyle(color: _blue, fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _blue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text('Officieel',
                            style: TextStyle(color: _blue, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(review.ownerResponse!,
                      style: const TextStyle(fontSize: 12, color: _textBody, height: 1.5)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.thumb_up_outlined,
                  color: _textSecondary, size: 13),
              const SizedBox(width: 6),
              Text(
                '${review.helpfulCount} nuttig',
                style: const TextStyle(fontSize: 11, color: _textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

