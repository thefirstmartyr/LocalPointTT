import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  UserModel? _currentUserModel;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) {
      return;
    }

    final userData = await _authService.getUserData(firebaseUser.uid);
    if (!mounted || userData == null) {
      return;
    }

    setState(() {
      _currentUserModel = userData;
      _firstNameController.text = userData.firstName;
      _lastNameController.text = userData.lastName;
      _emailController.text = userData.email;
      _phoneController.text = userData.phone ?? '';
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null || _currentUserModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load user profile.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = _currentUserModel!.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      await _authService.updateUserData(updatedUser);
      await firebaseUser.updateDisplayName(updatedUser.fullName);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty)
        ? '${_firstNameController.text[0]}${_lastNameController.text[0]}'.toUpperCase()
        : 'LP';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.firstName,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.errorRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingM),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.lastName,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.errorRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingM),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: AppStrings.email,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.errorRequired;
                  }
                  if (!value.contains('@')) {
                    return AppStrings.errorInvalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingM),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: AppStrings.phone,
                  hintText: 'Optional',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
