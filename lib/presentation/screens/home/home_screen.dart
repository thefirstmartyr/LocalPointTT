import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/services/firestore_data_service.dart';
import '../../../data/services/firestore_test_data.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_program_model.dart';
import '../../../data/models/business_model.dart';
import '../../../data/models/loyalty_program_model.dart';
import '../programs/program_detail_screen.dart';
import '../scan/scan_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/settings_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const StatsTab(),
    const HistoryTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ScanScreen(),
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
        backgroundColor: AppColors.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Tab
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirestoreDataService _dataService = FirestoreDataService();
  final AuthService _authService = AuthService();
  
  List<UserProgramModel> _userPrograms = [];
  Map<String, BusinessModel> _businesses = {};
  Map<String, LoyaltyProgramModel> _programs = {};
  int _totalPoints = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Load user programs
      final userPrograms = await _dataService.getUserPrograms(userId);
      
      // Load total points
      final totalPoints = await _dataService.getTotalUserPoints(userId);
      
      // Load business and program details for each user program
      final businesses = <String, BusinessModel>{};
      final programs = <String, LoyaltyProgramModel>{};
      
      for (var userProgram in userPrograms) {
        // Load business if not already loaded
        if (!businesses.containsKey(userProgram.businessId)) {
          final business = await _dataService.getBusinessById(userProgram.businessId);
          if (business != null) {
            businesses[userProgram.businessId] = business;
          }
        }
        
        // Load program if not already loaded
        if (!programs.containsKey(userProgram.programId)) {
          final program = await _dataService.getProgramById(userProgram.programId);
          if (program != null) {
            programs[userProgram.programId] = program;
          }
        }
      }

      if (mounted) {
        setState(() {
          _userPrograms = userPrograms;
          _businesses = businesses;
          _programs = programs;
          _totalPoints = totalPoints;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'Error loading data',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Your loyalty points at a glance',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              
              // Total points card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryVariant],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Points',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    Text(
                      _totalPoints.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    Text(
                      'Across ${_userPrograms.length} program${_userPrograms.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              
              // My Programs section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.yourPrograms,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingM),
              
              // Program cards
              if (_userPrograms.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingXL),
                    child: Column(
                      children: [
                        Icon(
                          Icons.card_membership,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        const Text(
                          'No Programs Yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        const Text(
                          'Start earning points by joining loyalty programs!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._userPrograms.map((userProgram) {
                  final business = _businesses[userProgram.businessId];
                  final program = _programs[userProgram.programId];
                  
                  if (business == null || program == null) {
                    return const SizedBox.shrink();
                  }
                  
                  // Calculate next reward milestone (simplified)
                  final nextMilestone = ((userProgram.currentPoints ~/ 100) + 1) * 100;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                    child: _buildProgramCard(
                      context: context,
                      businessName: business.name,
                      currentPoints: userProgram.currentPoints,
                      nextRewardPoints: nextMilestone,
                      nextRewardName: "Reward at $nextMilestone points",
                      qrCode: "${userProgram.userId}-${userProgram.programId}",
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgramCard({
    required BuildContext context,
    required String businessName,
    required int currentPoints,
    required int nextRewardPoints,
    required String nextRewardName,
    required String qrCode,
  }) {
    final progress = currentPoints / nextRewardPoints;
    final pointsNeeded = nextRewardPoints - currentPoints;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProgramDetailScreen(
              businessName: businessName,
              currentPoints: currentPoints,
              qrCode: qrCode,
            ),
          ),
        );
      },
      child: Card(
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
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          businessName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currentPoints points',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingM),
              
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                '$pointsNeeded more points to $nextRewardName',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stats Tab
class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Points',
                    value: '1,250',
                    icon: Icons.stars,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: _buildStatCard(
                    title: 'Programs',
                    value: '3',
                    icon: Icons.store,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'This Month',
                    value: '+340',
                    icon: Icons.trending_up,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: _buildStatCard(
                    title: 'Redeemed',
                    value: '5',
                    icon: Icons.redeem,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Monthly trend
            const Text(
              'Points Earned (Last 6 Months)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  children: [
                    _buildMonthBar('Jan', 0.4),
                    _buildMonthBar('Feb', 0.6),
                    _buildMonthBar('Mar', 0.5),
                    _buildMonthBar('Apr', 0.8),
                    _buildMonthBar('May', 0.7),
                    _buildMonthBar('Jun', 0.9),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Top programs
            const Text(
              'Most Active Programs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildProgramRankCard(1, "Joe's Coffee Shop", 450, 0.45),
            const SizedBox(height: AppDimensions.spacingS),
            _buildProgramRankCard(2, "Tech Store", 520, 0.52),
            const SizedBox(height: AppDimensions.spacingS),
            _buildProgramRankCard(3, "Best Bakery TT", 280, 0.28),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthBar(String month, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              month,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 20,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            '${(value * 1000).toInt()}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramRankCard(int rank, String name, int points, double percentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank == 1 ? AppColors.warning : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: rank == 1 ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 6,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Text(
              '$points pts',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// History Tab
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter tabs
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Row(
            children: [
              Expanded(
                child: _buildFilterChip('All', true),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: _buildFilterChip('Earned', false),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: _buildFilterChip('Redeemed', false),
              ),
            ],
          ),
        ),
        
        // Transaction list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            children: [
              _buildTransactionItem(
                icon: Icons.add_circle,
                iconColor: AppColors.success,
                title: "Joe's Coffee Shop",
                subtitle: 'Purchase points earned',
                points: '+50',
                pointsColor: AppColors.success,
                date: 'Today, 2:30 PM',
              ),
              _buildTransactionItem(
                icon: Icons.redeem,
                iconColor: AppColors.warning,
                title: "Best Bakery TT",
                subtitle: 'Redeemed: 10% Discount',
                points: '-300',
                pointsColor: AppColors.error,
                date: 'Yesterday, 11:15 AM',
              ),
              _buildTransactionItem(
                icon: Icons.add_circle,
                iconColor: AppColors.success,
                title: "Tech Store",
                subtitle: 'Purchase points earned',
                points: '+120',
                pointsColor: AppColors.success,
                date: 'Feb 25, 4:45 PM',
              ),
              _buildTransactionItem(
                icon: Icons.add_circle,
                iconColor: AppColors.success,
                title: "Joe's Coffee Shop",
                subtitle: 'Purchase points earned',
                points: '+50',
                pointsColor: AppColors.success,
                date: 'Feb 24, 9:20 AM',
              ),
              _buildTransactionItem(
                icon: Icons.card_giftcard,
                iconColor: AppColors.primary,
                title: "Welcome Bonus",
                subtitle: 'New member bonus',
                points: '+100',
                pointsColor: AppColors.success,
                date: 'Feb 23, 10:00 AM',
              ),
              _buildTransactionItem(
                icon: Icons.add_circle,
                iconColor: AppColors.success,
                title: "Best Bakery TT",
                subtitle: 'Purchase points earned',
                points: '+80',
                pointsColor: AppColors.success,
                date: 'Feb 22, 3:30 PM',
              ),
              _buildTransactionItem(
                icon: Icons.redeem,
                iconColor: AppColors.warning,
                title: "Joe's Coffee Shop",
                subtitle: 'Redeemed: Free Large Coffee',
                points: '-500',
                pointsColor: AppColors.error,
                date: 'Feb 20, 8:15 AM',
              ),
              _buildTransactionItem(
                icon: Icons.add_circle,
                iconColor: AppColors.success,
                title: "Tech Store",
                subtitle: 'Purchase points earned',
                points: '+200',
                pointsColor: AppColors.success,
                date: 'Feb 18, 1:00 PM',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String points,
    required Color pointsColor,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        trailing: Text(
          points,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: pointsColor,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}

// Profile Tab
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthService _authService = AuthService();
  String _userName = 'Loading...';
  String _userEmail = 'Loading...';
  String _userInitials = 'LP';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      if (mounted && userData != null) {
        setState(() {
          _userName = userData.fullName;
          _userEmail = userData.email;
          _userInitials = userData.initials;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spacingL),
            // Profile avatar
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _userInitials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              _userEmail,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Profile options
            _buildProfileOption(
              context,
              Icons.person_outline,
              'Edit Profile',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            _buildProfileOption(
              context,
              Icons.settings_outlined,
              'Settings',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _buildProfileOption(
              context,
              Icons.credit_card_outlined,
              'Payment Methods',
              () {
                // TODO: Navigate to payment methods
              },
            ),
            _buildProfileOption(
              context,
              Icons.notifications_outlined,
              'Notifications',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            _buildProfileOption(
              context,
              Icons.help_outline,
              'Help & Support',
              () {
                // TODO: Navigate to help
              },
            ),
            _buildProfileOption(
              context,
              Icons.info_outline,
              'About',
              () {
                _showAboutDialog(context);
              },
            ),
            
            // Debug: Add Test Data button (for development only)
            const SizedBox(height: AppDimensions.spacingL),
            const Divider(),
            const SizedBox(height: AppDimensions.spacingS),
            const Text(
              'Developer Tools',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _addTestData(context),
                icon: const Icon(Icons.data_object),
                label: const Text('Add Test Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<void> _addTestData(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Adding test data...'),
          ],
        ),
      ),
    );

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Add test data to Firestore
      await FirestoreTestData.addAllTestData(user.uid);

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test data added successfully! Pull to refresh on Home tab.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding test data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Local Point TT',
      children: [
        const SizedBox(height: AppDimensions.spacingM),
        const Text(
          AppStrings.appTagline,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        const Text(
          'Digital loyalty platform for local businesses in Trinidad and Tobago.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              
              // Sign out from Firebase
              await _authService.signOut();
              
              // Navigate to login screen
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
