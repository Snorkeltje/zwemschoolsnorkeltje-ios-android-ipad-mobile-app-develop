import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class _EmergencyContact {
  final String id;
  final String name;
  final String relation;
  final String phone;
  final bool isPrimary;

  const _EmergencyContact({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.isPrimary = false,
  });
}

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  final List<_EmergencyContact> _contacts = [
    const _EmergencyContact(
      id: 'ec_001',
      name: 'Sami Murtaza',
      relation: 'Vader',
      phone: '+31 6 12345678',
      isPrimary: true,
    ),
    const _EmergencyContact(
      id: 'ec_002',
      name: 'Fatima Murtaza',
      relation: 'Moeder',
      phone: '+31 6 87654321',
    ),
    const _EmergencyContact(
      id: 'ec_003',
      name: 'Jan de Vries',
      relation: 'Opa',
      phone: '+31 30 1234567',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Noodcontacten'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            color: AppColors.info.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Noodcontacten worden gebeld als we u niet kunnen bereiken tijdens een les.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.info.withValues(alpha: 1),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contacts list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              itemCount: _contacts.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.sm),
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return _buildContactCard(contact);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddContactDialog(),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Contact toevoegen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildContactCard(_EmergencyContact contact) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: contact.isPrimary
            ? Border.all(color: AppColors.primaryBlue, width: 1.5)
            : null,
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
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                child: Text(
                  contact.name.split(' ').map((w) => w[0]).take(2).join(),
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
                    Row(
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (contact.isPrimary) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Primair',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.relation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.textLight, size: 20),
                onSelected: (val) {
                  if (val == 'edit') {
                    _showAddContactDialog(existingContact: contact);
                  } else if (val == 'delete') {
                    _showDeleteDialog(contact);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Bewerken'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Verwijderen',
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                contact.phone,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bellen naar ${contact.phone}...')));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.call, size: 14, color: AppColors.success),
                      SizedBox(width: 4),
                      Text(
                        'Bellen',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog({_EmergencyContact? existingContact}) {
    final nameController =
        TextEditingController(text: existingContact?.name ?? '');
    final phoneController =
        TextEditingController(text: existingContact?.phone ?? '');
    final relationController =
        TextEditingController(text: existingContact?.relation ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.screenPadding,
          AppDimensions.screenPadding,
          AppDimensions.screenPadding,
          MediaQuery.of(context).viewInsets.bottom + AppDimensions.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              existingContact != null
                  ? 'Contact bewerken'
                  : 'Noodcontact toevoegen',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Naam',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: relationController,
              decoration: const InputDecoration(
                labelText: 'Relatie (bijv. Opa, Tante)',
                prefixIcon: Icon(Icons.family_restroom_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefoonnummer',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact opgeslagen'), backgroundColor: Color(0xFF27AE60)),
                  );
                },
                child: Text(
                  existingContact != null ? 'Opslaan' : 'Toevoegen',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(_EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          'Contact verwijderen',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Weet u zeker dat u ${contact.name} wilt verwijderen als noodcontact?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _contacts.removeWhere((c) => c.id == contact.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
  }
}
