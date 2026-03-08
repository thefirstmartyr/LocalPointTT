import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in with Firebase Auth
        final user = await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted && user != null) {
          setState(() {
            _isLoading = false;
          });
          
          // Navigate to home screen
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.signInWithGoogle();

      if (user == null) {
        // User cancelled
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingXXL),
                
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'LP',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Welcome back text
                const Text(
                  AppStrings.welcomeBack,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: AppStrings.email,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    if (!value.contains('@')) {
                      return AppStrings.errorInvalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    if (value.length < 8) {
                      return AppStrings.errorPasswordLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacingS),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                    },
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Sign in button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(AppStrings.signIn),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Divider with "or"
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Sign in with Google
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text(AppStrings.signInWithGoogle),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Don't have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.dontHaveAccount,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      key: const Key('login_sign_up_cta'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.registration);
                      },
                      child: const Text(AppStrings.signUp),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.staffLogin);
                    },
                    icon: const Icon(Icons.badge_outlined),
                    label: const Text('Staff login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
