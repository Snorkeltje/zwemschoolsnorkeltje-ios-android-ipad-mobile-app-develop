import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profiel'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          'SM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sami Murtaza',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'sami@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Children section
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mijn kinderen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to add child
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 16, color: AppColors.primaryBlue),
                              SizedBox(width: 4),
                              Text(
                                'Toevoegen',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildChildTile(context, 'Emma Murtaza', 'Beginner', 'EM', 6),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildChildTile(context, 'Noah Murtaza', 'Starter', 'NM', 4),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Menu items
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildMenuItem(
                    Icons.edit_outlined,
                    'Profiel bewerken',
                    onTap: () => context.pushNamed(RouteNames.editProfile),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.people_outline,
                    'Noodcontacten',
                    onTap: () {
                      // TODO: Navigate to emergency contacts
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.notifications_outlined,
                    'Notificatie-instellingen',
                    onTap: () => context.pushNamed(RouteNames.notificationSettings),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.payment_outlined,
                    'Betalingsgeschiedenis',
                    onTap: () => context.pushNamed(RouteNames.paymentHistory),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.credit_card_outlined,
                    'Betaalmethoden',
                    onTap: () => context.pushNamed(RouteNames.paymentMethod),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.help_outline,
                    'Veelgestelde vragen',
                    onTap: () => context.pushNamed(RouteNames.faq),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.description_outlined,
                    'Algemene voorwaarden',
                    onTap: () {
                      // TODO: Navigate to terms
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    Icons.info_outline,
                    'Over Snorkeltje',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Logout
            Container(
              color: AppColors.white,
              child: _buildMenuItem(
                Icons.logout,
                'Uitloggen',
                textColor: AppColors.error,
                iconColor: AppColors.error,
                onTap: () => _showLogoutDialog(context),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // App version
            const Text(
              'Zwemschool Snorkeltje v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildChildTile(BuildContext context, String name, String level, String initials, int age) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to edit child
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          level,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$age jaar',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (textColor != AppColors.error)
              const Icon(
                Icons.chevron_right,
                color: AppColors.textLight,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Divider(height: 1, color: AppColors.divider),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          'Uitloggen',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Weet u zeker dat u wilt uitloggen?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuleren',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Call auth provider logout
              context.goNamed(RouteNames.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: const Text('Uitloggen'),
          ),
        ],
      ),
    );
  }
}
