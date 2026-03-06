import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Mark all as read
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          _buildNotificationItem(
            icon: Icons.stars,
            iconColor: AppColors.warning,
            title: 'Points Earned!',
            message: "You earned 50 points at Joe's Coffee Shop",
            time: '5 min ago',
            isRead: false,
          ),
          _buildNotificationItem(
            icon: Icons.card_giftcard,
            iconColor: AppColors.success,
            title: 'Reward Available',
            message: 'You can now redeem a Free Large Coffee at Joe\'s Coffee Shop!',
            time: '2 hours ago',
            isRead: false,
          ),
          _buildNotificationItem(
            icon: Icons.celebration,
            iconColor: AppColors.primary,
            title: 'Special Offer!',
            message: 'Double points day at Best Bakery TT this weekend',
            time: '1 day ago',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.new_releases,
            iconColor: AppColors.secondary,
            title: 'New Program Available',
            message: 'A new business near you has joined Local Point TT',
            time: '2 days ago',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.trending_up,
            iconColor: AppColors.success,
            title: 'Milestone Reached!',
            message: 'Congratulations! You\'ve earned over 1,000 points',
            time: '3 days ago',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.redeem,
            iconColor: AppColors.warning,
            title: 'Reward Redeemed',
            message: 'You redeemed 10% Discount at Best Bakery TT',
            time: '5 days ago',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.info_outline,
            iconColor: AppColors.primary,
            title: 'App Update Available',
            message: 'Update to the latest version for new features',
            time: '1 week ago',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.lightbulb_outline,
            iconColor: AppColors.secondary,
            title: 'Tip',
            message: 'Did you know? You can track your stats in the Stats tab',
            time: '1 week ago',
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool isRead,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      color: isRead ? null : AppColors.primaryLight.withValues(alpha: 0.3),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          // TODO: Navigate to relevant screen based on notification type
        },
      ),
    );
  }
}
