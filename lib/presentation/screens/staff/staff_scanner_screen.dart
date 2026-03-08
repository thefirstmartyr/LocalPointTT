import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../scan/scan_success_screen.dart';
import 'manual_customer_lookup_screen.dart';

class StaffScannerScreen extends StatefulWidget {
  const StaffScannerScreen({super.key});

  @override
  State<StaffScannerScreen> createState() => _StaffScannerScreenState();
}

class _StaffScannerScreenState extends State<StaffScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing || capture.barcodes.isEmpty) {
      return;
    }

    final code = capture.barcodes.first.rawValue;
    if (code == null || code.trim().isEmpty) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScanSuccessScreen(
          title: 'Points Applied',
          message: 'Customer transaction processed for code: $code',
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: _controller.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: _controller.switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              color: Colors.black.withValues(alpha: 0.55),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Scan customer QR to apply points',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ManualCustomerLookupScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      icon: const Icon(Icons.search),
                      label: const Text('Manual Customer Lookup'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
