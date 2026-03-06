import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/local_storage_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    
    print('🎬 SplashScreen initState');
    
    _navigateToNextScreen();
  }
  
  Future<void> _navigateToNextScreen() async {
    print('⏳ Waiting 2 seconds...');
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if onboarding is complete
    bool onboardingComplete = LocalStorageService.isOnboardingComplete();
    print('📋 Onboarding complete: $onboardingComplete');
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => onboardingComplete 
            ? const LoginScreen() 
            : const OnboardingScreen(),
      ),
    );
    print('✅ Navigation complete');
  }
  
  @override
  Widget build(BuildContext context) {
    print('🎨 SplashScreen build() called');
    print('📐 MediaQuery size: ${MediaQuery.of(context).size}');
    return Scaffold(
      backgroundColor: AppColors.primary, // Changed to primary color for visibility
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder - replace with actual logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Center(
                  child: Text(
                    'LP',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Loading dots animation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
