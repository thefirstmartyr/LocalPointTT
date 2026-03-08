import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with Firebase Auth and Firestore
        await _authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty 
              ? null 
              : _phoneController.text.trim(),
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.successAccountCreated),
              backgroundColor: Colors.green,
            ),
          );
          
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

  Future<void> _handleGoogleSignUp() async {
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
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key('registration_scroll_view'),
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Text(
                  AppStrings.createAccount,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                const Text(
                  'Sign up to start earning points',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                
                // First Name field
                TextFormField(
                  key: const Key('reg_first_name_field'),
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: AppStrings.firstName,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Last Name field
                TextFormField(
                  key: const Key('reg_last_name_field'),
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: AppStrings.lastName,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Email field
                TextFormField(
                  key: const Key('reg_email_field'),
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
                
                // Phone field
                TextFormField(
                  key: const Key('reg_phone_field'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: AppStrings.phone,
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: 'Optional (e.g. +1 868-123-4567)',
                  ),
                  validator: (value) {
                    // Phone is optional, but if entered it should be a valid length.
                    final phone = value?.trim() ?? '';
                    if (phone.isEmpty) {
                      return null;
                    }
                    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
                    if (digitsOnly.length < 7) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Password field
                TextFormField(
                  key: const Key('reg_password_field'),
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
                const SizedBox(height: AppDimensions.spacingM),
                
                // Confirm Password field
                TextFormField(
                  key: const Key('reg_confirm_password_field'),
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: AppStrings.confirmPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    if (value != _passwordController.text) {
                      return AppStrings.errorPasswordMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacingM),
                
                // Terms and conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      key: const Key('reg_terms_checkbox'),
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          children: [
                            const Text(
                              'I agree to the ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.legalInfo,
                                  arguments: {
                                    'title': 'Terms of Service',
                                    'content': 'Terms of Service content will be displayed here. This should be replaced with actual legal text from your organization.',
                                  },
                                );
                              },
                              child: const Text(
                                'Terms of Service',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(
                              ' and ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.legalInfo,
                                  arguments: {
                                    'title': 'Privacy Policy',
                                    'content': 'Privacy Policy content will be displayed here. This should be replaced with actual legal text from your organization.',
                                  },
                                );
                              },
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Sign up button
                ElevatedButton(
                  key: const Key('reg_submit_button'),
                  onPressed: _isLoading ? null : _handleRegistration,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(AppStrings.signUp),
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
                
                // Sign up with Google
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignUp,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Sign up with Google'),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyHaveAccount,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(AppStrings.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
