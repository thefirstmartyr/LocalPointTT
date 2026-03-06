import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class ProgramDetailScreen extends StatelessWidget {
  final String businessName;
  final int currentPoints;
  final String qrCode;

  const ProgramDetailScreen({
    super.key,
    required this.businessName,
    required this.currentPoints,
    required this.qrCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(businessName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Business header
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingXL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryVariant],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Business logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    businessName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    '$currentPoints points',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            
            // QR Code section
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXL),
              child: Column(
                children: [
                  const Text(
                    AppStrings.showAtCheckout,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  
                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingL),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: qrCode,
                      version: QrVersions.auto,
                      size: 250,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    AppStrings.tapToEnlarge,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Rewards section
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Rewards',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  
                  // Reward cards
                  _buildRewardCard(
                    title: 'Free Large Coffee',
                    points: 500,
                    currentPoints: currentPoints,
                    description: 'Any size, any flavor',
                    icon: Icons.local_cafe,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  _buildRewardCard(
                    title: '10% Off Purchase',
                    points: 300,
                    currentPoints: currentPoints,
                    description: 'Valid on any purchase',
                    icon: Icons.discount,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  _buildRewardCard(
                    title: 'Free Pastry',
                    points: 200,
                    currentPoints: currentPoints,
                    description: 'Choose from daily selection',
                    icon: Icons.cake,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  _buildRewardCard(
                    title: 'Buy 1 Get 1 Free',
                    points: 750,
                    currentPoints: currentPoints,
                    description: 'On selected items',
                    icon: Icons.redeem,
                  ),
                ],
              ),
            ),
            
            // Program details
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Program Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.card_giftcard, 'Earn 10 points per \$1 spent'),
                          const SizedBox(height: AppDimensions.spacingM),
                          _buildDetailRow(Icons.location_on, '123 Main Street, Port of Spain'),
                          const SizedBox(height: AppDimensions.spacingM),
                          _buildDetailRow(Icons.access_time, 'Mon-Sat: 8am-8pm, Sun: 9am-5pm'),
                          const SizedBox(height: AppDimensions.spacingM),
                          _buildDetailRow(Icons.phone, '+1 868-123-4567'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard({
    required String title,
    required int points,
    required int currentPoints,
    required String description,
    required IconData icon,
  }) {
    final bool canRedeem = currentPoints >= points;
    final double progress = (currentPoints / points).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: canRedeem ? AppColors.successLight : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Icon(
                    icon,
                    color: canRedeem ? AppColors.success : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
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
                      '$points pts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: canRedeem ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    if (canRedeem)
                      const Text(
                        'Ready!',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (!canRedeem) ...[
              const SizedBox(height: AppDimensions.spacingM),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                '${points - currentPoints} more points needed',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (canRedeem) ...[
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement redeem functionality
                  },
                  child: const Text('Redeem Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
