import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

enum PaymentStatus { completed, pending, failed, refunded }

class _PaymentRecord {
  final String id;
  final String description;
  final String date;
  final double amount;
  final PaymentStatus status;
  final String paymentMethod;

  const _PaymentRecord({
    required this.id,
    required this.description,
    required this.date,
    required this.amount,
    required this.status,
    required this.paymentMethod,
  });
}

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _selectedFilter = 'Alle';

  final List<String> _filters = ['Alle', 'Voltooid', 'In behandeling', 'Mislukt'];

  final List<_PaymentRecord> _payments = const [
    _PaymentRecord(
      id: 'pay_001',
      description: 'Zwemles 1-op-1 - Emma',
      date: '28 maart 2026',
      amount: 30.50,
      status: PaymentStatus.completed,
      paymentMethod: 'Visa ****4242',
    ),
    _PaymentRecord(
      id: 'pay_002',
      description: 'Knipkaart 10x 1-op-1',
      date: '25 maart 2026',
      amount: 275.00,
      status: PaymentStatus.completed,
      paymentMethod: 'Visa ****4242',
    ),
    _PaymentRecord(
      id: 'pay_003',
      description: 'Zwemles 1-op-2 - Noah',
      date: '22 maart 2026',
      amount: 22.00,
      status: PaymentStatus.completed,
      paymentMethod: 'Knipkaart',
    ),
    _PaymentRecord(
      id: 'pay_004',
      description: 'Extra les 1-op-1 - Emma',
      date: '18 maart 2026',
      amount: 30.50,
      status: PaymentStatus.refunded,
      paymentMethod: 'Visa ****4242',
    ),
    _PaymentRecord(
      id: 'pay_005',
      description: 'Vakantie zwemles - Noah',
      date: '15 maart 2026',
      amount: 35.00,
      status: PaymentStatus.completed,
      paymentMethod: 'Mastercard ****8888',
    ),
    _PaymentRecord(
      id: 'pay_006',
      description: 'Zwemles 1-op-1 - Emma',
      date: '12 maart 2026',
      amount: 30.50,
      status: PaymentStatus.failed,
      paymentMethod: 'Visa ****4242',
    ),
  ];

  List<_PaymentRecord> get _filteredPayments {
    if (_selectedFilter == 'Alle') return _payments;
    return _payments.where((p) {
      switch (_selectedFilter) {
        case 'Voltooid':
          return p.status == PaymentStatus.completed;
        case 'In behandeling':
          return p.status == PaymentStatus.pending;
        case 'Mislukt':
          return p.status == PaymentStatus.failed || p.status == PaymentStatus.refunded;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPayments;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Betalingsgeschiedenis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary card
          Container(
            width: double.infinity,
            color: AppColors.white,
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Totaal deze maand',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\u20AC 358,00',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '6 transacties',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Maart 2026',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter chips
          Container(
            color: AppColors.white,
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0365C4)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0365C4)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF818EA6),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Payment list
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Geen betalingen gevonden',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.screenPadding),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      return _PaymentTile(payment: filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final _PaymentRecord payment;

  const _PaymentTile({required this.payment});

  Color _statusColor() {
    switch (payment.status) {
      case PaymentStatus.completed:
        return AppColors.success;
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.refunded:
        return AppColors.info;
    }
  }

  String _statusText() {
    switch (payment.status) {
      case PaymentStatus.completed:
        return 'Voltooid';
      case PaymentStatus.pending:
        return 'In behandeling';
      case PaymentStatus.failed:
        return 'Mislukt';
      case PaymentStatus.refunded:
        return 'Terugbetaald';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  payment.status == PaymentStatus.completed
                      ? Icons.check_circle_outline
                      : payment.status == PaymentStatus.failed
                          ? Icons.error_outline
                          : payment.status == PaymentStatus.refunded
                              ? Icons.replay
                              : Icons.schedule,
                  color: _statusColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      payment.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\u20AC ${payment.amount.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _statusText(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payment.paymentMethod,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/invoice/${payment.id}');
                },
                child: const Text(
                  'Bekijk factuur',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
