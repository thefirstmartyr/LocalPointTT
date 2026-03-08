import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ManualCustomerLookupScreen extends StatefulWidget {
  const ManualCustomerLookupScreen({super.key});

  @override
  State<ManualCustomerLookupScreen> createState() => _ManualCustomerLookupScreenState();
}

class _ManualCustomerLookupScreenState extends State<ManualCustomerLookupScreen> {
  final TextEditingController _lookupController = TextEditingController();
  bool _isSearching = false;
  String? _result;

  @override
  void dispose() {
    _lookupController.dispose();
    super.dispose();
  }

  Future<void> _lookupCustomer() async {
    final query = _lookupController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email, phone, or customer ID')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _result = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSearching = false;
      _result = 'Customer found for "$query"';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual Customer Lookup')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _lookupController,
              decoration: const InputDecoration(
                labelText: 'Customer Email / Phone / ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            ElevatedButton.icon(
              onPressed: _isSearching ? null : _lookupCustomer,
              icon: const Icon(Icons.person_search),
              label: Text(_isSearching ? 'Searching...' : 'Lookup Customer'),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            if (_result != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.verified_user, color: AppColors.success),
                  title: Text(_result!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
