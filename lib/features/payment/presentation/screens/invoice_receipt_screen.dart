import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class InvoiceReceiptScreen extends StatelessWidget {
  final String? paymentId;

  const InvoiceReceiptScreen({super.key, this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Factuur'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Share invoice
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Download invoice PDF
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
              padding: const EdgeInsets.all(AppDimensions.sectionSpacing),
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
                  // Logo / Header
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.pool,
                      size: 28,
                      color: AppColors.primaryBlue,
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
                  const SizedBox(height: AppDimensions.sectionSpacing),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Betaald',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionSpacing),

                  // Invoice details
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.md),

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

                  const SizedBox(height: AppDimensions.md),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.md),

                  // Price breakdown
                  _buildPriceRow('Subtotaal', '\u20AC 25,21'),
                  const SizedBox(height: 8),
                  _buildPriceRow('BTW (21%)', '\u20AC 5,29'),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),
                  _buildPriceRow('Totaal', '\u20AC 30,50', isBold: true),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Download button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Download PDF
                },
                icon: const Icon(Icons.download, size: 20),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.md),

            // Send by email button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Send by email
                },
                icon: const Icon(Icons.email_outlined, size: 20),
                label: const Text(
                  'Verstuur per e-mail',
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
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
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
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
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
