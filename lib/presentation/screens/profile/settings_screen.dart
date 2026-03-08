import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _promotionalEmails = false;
  bool _biometricAuth = false;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _pushNotifications = LocalStorageService.getBool('settings_push_notifications', defaultValue: true);
      _emailNotifications = LocalStorageService.getBool('settings_email_notifications');
      _smsNotifications = LocalStorageService.getBool('settings_sms_notifications', defaultValue: true);
      _promotionalEmails = LocalStorageService.getBool('settings_promotional_emails');
      _biometricAuth = LocalStorageService.getBool('settings_biometric_auth');
      _language = LocalStorageService.getString('settings_language', defaultValue: 'English');
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    await LocalStorageService.setBool(key, value);
  }

  Future<void> _saveLanguage(String value) async {
    await LocalStorageService.setString('settings_language', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingL),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive notifications on your device'),
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                    _saveBool('settings_push_notifications', value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive updates via email'),
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                    _saveBool('settings_email_notifications', value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('SMS Notifications'),
                  subtitle: const Text('Receive text message alerts'),
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() {
                      _smsNotifications = value;
                    });
                    _saveBool('settings_sms_notifications', value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Promotional Emails'),
                  subtitle: const Text('Receive special offers and promotions'),
                  value: _promotionalEmails,
                  onChanged: (value) {
                    setState(() {
                      _promotionalEmails = value;
                    });
                    _saveBool('settings_promotional_emails', value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingL),
            child: Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Biometric Authentication'),
                  subtitle: const Text('Use fingerprint or face ID to login'),
                  value: _biometricAuth,
                  onChanged: (value) {
                    setState(() {
                      _biometricAuth = value;
                    });
                    _saveBool('settings_biometric_auth', value);
                  },
                  secondary: const Icon(Icons.fingerprint, color: AppColors.primary),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.changePassword);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingL),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: const Text('Language'),
                  subtitle: Text(_language),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showLanguageDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: AppColors.primary),
                  title: const Text('Dark Mode'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dark mode is planned for a later release.')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingL),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.legalInfo,
                      arguments: {
                        'title': 'Privacy Policy',
                        'content':
                            'Local Point TT collects only the data needed to run loyalty programs. '
                            'Your profile and transaction data are stored securely and are not sold to third parties.',
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.legalInfo,
                      arguments: {
                        'title': 'Terms of Service',
                        'content':
                            'By using Local Point TT, you agree to follow program rules set by participating businesses. '
                            'Abuse of rewards or fraudulent activity may lead to account suspension.',
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.primary),
                  title: Text('App Version'),
                  trailing: Text('1.0.0'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _language = value;
                });
                _saveLanguage(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _language,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _language = value;
                });
                _saveLanguage(value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
