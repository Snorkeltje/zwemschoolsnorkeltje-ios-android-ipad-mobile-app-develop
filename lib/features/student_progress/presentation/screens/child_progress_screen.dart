import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

class _SkillData {
  final String name;
  final int completedSteps;
  final int totalSteps;
  final List<String> steps;

  const _SkillData({
    required this.name,
    required this.completedSteps,
    required this.totalSteps,
    required this.steps,
  });

  double get progress => totalSteps > 0 ? completedSteps / totalSteps : 0;

  Color get statusColor {
    if (completedSteps == totalSteps) return AppColors.success;
    if (completedSteps > 0) return AppColors.primaryBlue;
    return AppColors.textLight;
  }

  String get statusLabel {
    if (completedSteps == totalSteps) return 'Voltooid';
    if (completedSteps > 0) return 'Bezig';
    return 'Niet gestart';
  }
}

class ChildProgressScreen extends StatefulWidget {
  const ChildProgressScreen({super.key});

  @override
  State<ChildProgressScreen> createState() => _ChildProgressScreenState();
}

class _ChildProgressScreenState extends State<ChildProgressScreen> {
  int _selectedChildIndex = 0;

  final List<Map<String, String>> _children = [
    {'name': 'Emma Murtaza', 'level': 'Beginner', 'initials': 'EM'},
    {'name': 'Noah Murtaza', 'level': 'Starter', 'initials': 'NM'},
  ];

  // Mock skills data per child
  final List<List<_SkillData>> _skillsByChild = [
    // Emma's skills
    [
      _SkillData(
        name: 'Watergewenning',
        completedSteps: 5,
        totalSteps: 5,
        steps: [
          'Gezicht in het water',
          'Blazen onder water',
          'Ogen open onder water',
          'Onderdompelen',
          'Springen in het water',
        ],
      ),
      _SkillData(
        name: 'Drijven',
        completedSteps: 3,
        totalSteps: 5,
        steps: [
          'Drijven op de buik met steun',
          'Drijven op de rug met steun',
          'Drijven op de buik zonder steun',
          'Drijven op de rug zonder steun',
          'Ster drijven',
        ],
      ),
      _SkillData(
        name: 'Borstcrawl armen',
        completedSteps: 2,
        totalSteps: 4,
        steps: [
          'Armslag met plank',
          'Armslag zonder plank',
          'Armslag met ademhaling',
          'Volledige borstcrawl armen',
        ],
      ),
      _SkillData(
        name: 'Rugcrawl',
        completedSteps: 0,
        totalSteps: 4,
        steps: [
          'Rugligging met steun',
          'Beenslag op de rug',
          'Armslag op de rug',
          'Volledige rugcrawl',
        ],
      ),
      _SkillData(
        name: 'Ademhaling',
        completedSteps: 1,
        totalSteps: 3,
        steps: [
          'Uitblazen onder water',
          'Ritmisch ademhalen',
          'Bilateraal ademhalen',
        ],
      ),
    ],
    // Noah's skills
    [
      _SkillData(
        name: 'Watergewenning',
        completedSteps: 2,
        totalSteps: 5,
        steps: [
          'Gezicht in het water',
          'Blazen onder water',
          'Ogen open onder water',
          'Onderdompelen',
          'Springen in het water',
        ],
      ),
      _SkillData(
        name: 'Drijven',
        completedSteps: 0,
        totalSteps: 5,
        steps: [
          'Drijven op de buik met steun',
          'Drijven op de rug met steun',
          'Drijven op de buik zonder steun',
          'Drijven op de rug zonder steun',
          'Ster drijven',
        ],
      ),
    ],
  ];

  int get _totalCompleted {
    final skills = _skillsByChild[_selectedChildIndex];
    return skills.fold(0, (sum, s) => sum + s.completedSteps);
  }

  int get _totalSteps {
    final skills = _skillsByChild[_selectedChildIndex];
    return skills.fold(0, (sum, s) => sum + s.totalSteps);
  }

  double get _overallProgress =>
      _totalSteps > 0 ? _totalCompleted / _totalSteps : 0;

  @override
  Widget build(BuildContext context) {
    final child = _children[_selectedChildIndex];
    final skills = _skillsByChild[_selectedChildIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.childProgress),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child selector
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _children.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedChildIndex;
                  final c = _children[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedChildIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlue.withValues(alpha: 0.1)
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.textLight,
                            child: Text(
                              c['initials']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c['name']!.split(' ').first,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Current level card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, Color(0xFF0480E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Huidig niveau',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          child['level']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(_overallProgress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_totalCompleted van $_totalSteps stappen voltooid',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _overallProgress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Skills section
            const Text(
              AppStrings.skills,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            ...skills.map(
              (skill) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: _SkillCard(skill: skill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final _SkillData skill;

  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final skill = widget.skill;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.shadowBlur,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (tappable)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              child: Row(
                children: [
                  // Status icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: skill.statusColor.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Icon(
                      skill.completedSteps == skill.totalSteps
                          ? Icons.check_circle
                          : skill.completedSteps > 0
                              ? Icons.timelapse
                              : Icons.radio_button_unchecked,
                      color: skill.statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: skill.progress,
                                  minHeight: 6,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    skill.statusColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${skill.completedSteps}/${skill.totalSteps}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: skill.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      skill.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: skill.statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textLight,
                  ),
                ],
              ),
            ),
          ),
          // Expandable steps
          if (_isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 8),
                  ...List.generate(skill.steps.length, (i) {
                    final isCompleted = i < skill.completedSteps;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 18,
                            color: isCompleted
                                ? AppColors.success
                                : AppColors.textLight,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              skill.steps[i],
                              style: TextStyle(
                                fontSize: 13,
                                color: isCompleted
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
