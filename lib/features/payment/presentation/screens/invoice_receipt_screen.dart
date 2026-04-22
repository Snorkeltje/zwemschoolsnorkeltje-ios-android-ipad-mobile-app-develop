import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/smart_back.dart';

class InvoiceReceiptScreen extends StatelessWidget {
  final String? paymentId;

  const InvoiceReceiptScreen({super.key, this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => smartBack(context),
        ),
        centerTitle: true,
        title: const Text(
          'Factuur',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Factuur delen...')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined,
                color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF wordt gedownload...')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            // Invoice card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo / Header
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0365C4).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.pool,
                      size: 28,
                      color: Color(0xFF0365C4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Zwemschool Snorkeltje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Factuur #INV-2026-0328',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFF27AE60), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Betaald',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF27AE60),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Invoice details
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),

                  _buildDetailRow('Datum', '28 maart 2026'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Beschrijving', 'Zwemles 1-op-1 - Emma'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Locatie', 'De Bilt'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Datum les', '31 maart 2026, 15:00'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Instructeur', 'Anna de Vries'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Betaalmethode', 'Visa ****4242'),

                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),

                  // Price breakdown
                  _buildPriceRow('Subtotaal', '\u20AC 25,21'),
                  const SizedBox(height: 8),
                  _buildPriceRow('BTW (21%)', '\u20AC 5,29'),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  _buildPriceRow('Totaal', '\u20AC 30,50', isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Download button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF wordt gedownload...')));
                },
                icon: const Icon(Icons.download, size: 20),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0365C4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Send by email button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Factuur wordt per e-mail verstuurd...')));
                },
                icon: const Icon(Icons.email_outlined, size: 20),
                label: const Text(
                  'Verstuur per e-mail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0365C4),
                  side: const BorderSide(color: Color(0xFF0365C4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? const Color(0xFF0365C4) : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
