import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_NotificationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _NotificationItem(
        icon: Icons.stars,
        iconColor: AppColors.warning,
        title: 'Points Earned!',
        message: "You earned 50 points at Joe's Coffee Shop",
        time: '5 min ago',
        routeHint: 'history',
      ),
      _NotificationItem(
        icon: Icons.card_giftcard,
        iconColor: AppColors.success,
        title: 'Reward Available',
        message: 'You can now redeem a Free Large Coffee at Joe\'s Coffee Shop!',
        time: '2 hours ago',
      ),
      _NotificationItem(
        icon: Icons.celebration,
        iconColor: AppColors.primary,
        title: 'Special Offer!',
        message: 'Double points day at Best Bakery TT this weekend',
        time: '1 day ago',
        isRead: true,
      ),
      _NotificationItem(
        icon: Icons.new_releases,
        iconColor: AppColors.secondary,
        title: 'New Program Available',
        message: 'A new business near you has joined Local Point TT',
        time: '2 days ago',
        isRead: true,
        routeHint: 'scan',
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      _items = _items.map((item) => item.copyWith(isRead: true)).toList();
    });
  }

  void _handleTap(int index) {
    final tapped = _items[index];

    setState(() {
      _items[index] = tapped.copyWith(isRead: true);
    });

    final target = tapped.routeHint ?? 'details';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open $target for: ${tapped.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildNotificationItem(
                  item: item,
                  onTap: () => _handleTap(index),
                );
              },
            ),
    );
  }

  Widget _buildNotificationItem({
    required _NotificationItem item,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      color: item.isRead ? null : AppColors.primaryLight.withValues(alpha: 0.3),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: item.iconColor, size: 24),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (!item.isRead)
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
              item.message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.time,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String? routeHint;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.routeHint,
  });

  _NotificationItem copyWith({
    IconData? icon,
    Color? iconColor,
    String? title,
    String? message,
    String? time,
    bool? isRead,
    String? routeHint,
  }) {
    return _NotificationItem(
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      routeHint: routeHint ?? this.routeHint,
    );
  }
}
