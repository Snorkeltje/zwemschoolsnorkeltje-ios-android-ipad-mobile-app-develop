import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/smart_back.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  int _expandedLocationIndex = -1;
  // Walter: contact regular instructor OR Snorkeltje team
  String _recipient = 'team'; // 'instructor' or 'team'
  bool _isComplaint = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. GRADIENT HEADER
            _buildGradientHeader(context),
            const SizedBox(height: 20),

            // 2. QUICK CONTACT CARDS
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildQuickContactCards(),
            ),
            const SizedBox(height: 20),

            // 3. OPENING HOURS
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildOpeningHours(),
            ),
            const SizedBox(height: 20),

            // 4. LOCATIONS
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildLocations(),
            ),
            const SizedBox(height: 20),

            // 5. CONTACT FORM
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildContactForm(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. GRADIENT HEADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildGradientHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1, -1),
          end: Alignment(1, 1),
          colors: [
            Color(0xFF0365C4),
            Color(0xFF0D7FE8),
            Color(0xFF00C1FF),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: CustomPaint(
                size: const Size(double.infinity, 60),
                painter: _WavePainter(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topPadding + 8,
              bottom: 32,
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
            ),
            child: Column(
              children: [
                // Back button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => smartBack(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Neem contact met ons op',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. QUICK CONTACT CARDS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildQuickContactCards() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickContactCard(
            icon: Icons.phone,
            label: 'Bellen',
            color: const Color(0xFF27AE60),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildQuickContactCard(
            icon: Icons.email_outlined,
            label: 'E-mail',
            color: const Color(0xFF0365C4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildQuickContactCard(
            icon: Icons.chat_bubble_outline,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickContactCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. OPENING HOURS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildOpeningHours() {
    final hours = [
      {'day': 'Maandag - Vrijdag', 'time': '09:00 - 20:00'},
      {'day': 'Zaterdag', 'time': '09:00 - 17:00'},
      {'day': 'Zondag', 'time': 'Gesloten'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5C00).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.access_time,
                    color: Color(0xFFFF5C00), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Openingstijden',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...hours.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      h['day']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      h['time']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: h['time'] == 'Gesloten'
                            ? const Color(0xFFE74C3C)
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. LOCATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLocations() {
    final locations = [
      {
        'name': 'Zwembad De Kwakel',
        'address': 'Kwakelweg 12, 3521 Utrecht',
        'initial': 'K',
        'colors': [const Color(0xFF0365C4), const Color(0xFF00C1FF)]
      },
      {
        'name': 'Sportcentrum Olympos',
        'address': 'Uppsalalaan 3, 3584 Utrecht',
        'initial': 'O',
        'colors': [const Color(0xFF27AE60), const Color(0xFF6FCF97)]
      },
      {
        'name': 'Zwembad Fletiomare',
        'address': 'Sweelincklaan 1, 3723 De Bilt',
        'initial': 'F',
        'colors': [const Color(0xFFFF5C00), const Color(0xFFF5A623)]
      },
      {
        'name': 'Zwembad De Vliet',
        'address': 'Leidseweg 4, 3531 Utrecht',
        'initial': 'V',
        'colors': [const Color(0xFF8E44AD), const Color(0xFFBB6BD9)]
      },
      {
        'name': 'Zwembad Merwestein',
        'address': 'Dillenburgstraat 2, 3431 Nieuwegein',
        'initial': 'M',
        'colors': [const Color(0xFF0365C4), const Color(0xFF5BC1DB)]
      },
      {
        'name': 'Zwembad De Boog',
        'address': 'Boogstraat 8, 3512 Utrecht',
        'initial': 'B',
        'colors': [const Color(0xFFF5A623), const Color(0xFFFFD93D)]
      },
      {
        'name': 'Zwembad Krommerijn',
        'address': 'Mytylweg 1, 3581 Utrecht',
        'initial': 'K',
        'colors': [const Color(0xFF27AE60), const Color(0xFF00C1FF)]
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0365C4).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: Color(0xFF0365C4), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Onze locaties',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(locations.length, (index) {
            final loc = locations[index];
            final isExpanded = _expandedLocationIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _expandedLocationIndex = isExpanded ? -1 : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? const Color(0xFF0365C4).withValues(alpha: 0.05)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: isExpanded
                      ? Border.all(
                          color:
                              const Color(0xFF0365C4).withValues(alpha: 0.2))
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: loc['colors'] as List<Color>,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              loc['initial'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            loc['name'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.textLight,
                          size: 22,
                        ),
                      ],
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 52),
                          const Icon(Icons.place,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            loc['address'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. CONTACT FORM
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stuur een bericht',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kies aan wie u wilt schrijven',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          // Recipient selector — Walter: regular instructor OR team
          Row(
            children: [
              Expanded(
                child: _recipientCard(
                  selected: _recipient == 'instructor',
                  icon: Icons.person,
                  title: 'Mijn Instructeur',
                  subtitle: 'Jan de Vries',
                  color: const Color(0xFF0365C4),
                  onTap: () => setState(() {
                    _recipient = 'instructor';
                    _isComplaint = false;
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _recipientCard(
                  selected: _recipient == 'team',
                  icon: Icons.groups_2,
                  title: 'Snorkeltje Team',
                  subtitle: 'Walter & team',
                  color: const Color(0xFFFF5C00),
                  onTap: () => setState(() => _recipient = 'team'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Complaint toggle — Walter: complaints always CC'd to team
          GestureDetector(
            onTap: () => setState(() => _isComplaint = !_isComplaint),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isComplaint
                    ? const Color(0xFFE74C3C).withValues(alpha: 0.08)
                    : const Color(0xFFF4F7FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isComplaint
                      ? const Color(0xFFE74C3C).withValues(alpha: 0.3)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: _isComplaint ? const Color(0xFFE74C3C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _isComplaint ? const Color(0xFFE74C3C) : const Color(0xFFD0D5DD),
                        width: 2,
                      ),
                    ),
                    child: _isComplaint
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Dit is een klacht',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (_isComplaint)
                    const Text(
                      'Team wordt ook ingelicht',
                      style: TextStyle(color: Color(0xFFE74C3C), fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildFormField('Naam', 'Uw volledige naam', _nameController,
              Icons.person_outline),
          const SizedBox(height: 14),
          _buildFormField('E-mail', 'uw@email.nl', _emailController,
              Icons.email_outlined),
          const SizedBox(height: 14),
          _buildFormField('Onderwerp', 'Waar gaat het over?',
              _subjectController, Icons.subject),
          const SizedBox(height: 14),
          _buildFormField(
            'Bericht',
            'Typ uw bericht hier...',
            _messageController,
            Icons.message_outlined,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          // Send button
          GestureDetector(
            onTap: () {
              final target = _recipient == 'instructor' ? 'uw instructeur' : 'Snorkeltje team';
              final complaintNote = _isComplaint ? ' (ook naar team verzonden)' : '';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Bericht verzonden naar $target$complaintNote'),
                    backgroundColor: const Color(0xFF27AE60)),
              );
              _nameController.clear();
              _emailController.clear();
              _subjectController.clear();
              _messageController.clear();
              setState(() => _isComplaint = false);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5C00), Color(0xFFF5A623)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5C00).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    _recipient == 'instructor' ? 'Verstuur naar instructeur' : 'Verstuur naar team',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipientCard({
    required bool selected,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: selected ? color : color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 17,
                    color: selected ? Colors.white : color,
                  ),
                ),
                const Spacer(),
                if (selected)
                  Icon(Icons.check_circle, color: color, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                  color: selected ? color : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                )),
            Text(subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, String hint,
      TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
              prefixIcon: maxLines == 1
                  ? Icon(icon, color: AppColors.textLight, size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: maxLines > 1 ? 14 : 0,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// WAVE PAINTER
// ═══════════════════════════════════════════════════════════════════════════
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.8,
        size.width,
        size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
