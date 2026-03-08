import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_data_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  final FirestoreDataService _dataService = FirestoreDataService();
  final AuthService _authService = AuthService();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _tryJoinProgram(code.trim());

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.scanSuccess,
        arguments: {
          'title': 'Program Joined!',
          'message': result,
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<String> _tryJoinProgram(String rawCode) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      throw Exception('You must be logged in to join a program.');
    }

    // Expected format: <programId>|<businessId>
    final parts = rawCode.split('|');
    if (parts.length == 2) {
      final programId = parts[0].trim();
      final businessId = parts[1].trim();

      if (programId.isNotEmpty && businessId.isNotEmpty) {
        await _dataService.enrollUserInProgram(
          userId: userId,
          programId: programId,
          businessId: businessId,
        );
        return 'Successfully joined loyalty program $programId.';
      }
    }

    throw Exception('Invalid QR code format. Use programId|businessId.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.grey),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt_outlined, size: 40, color: AppColors.error),
                      const SizedBox(height: AppDimensions.spacingS),
                      Text(
                        'Camera error: ${error.errorCode.name}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Overlay with instructions
          Column(
            children: [
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spacingXL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingL,
                        vertical: AppDimensions.spacingM,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 48,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppDimensions.spacingM),
                          const Text(
                            'Position QR code within frame',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingS),
                          const Text(
                            'The QR code will be scanned automatically',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Scanning frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
          ),
          
          // Corner decorations
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 4),
                          left: BorderSide(color: Colors.white, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppDimensions.radiusL),
                        ),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 4),
                          right: BorderSide(color: Colors.white, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(AppDimensions.radiusL),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4),
                          left: BorderSide(color: Colors.white, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppDimensions.radiusL),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4),
                          right: BorderSide(color: Colors.white, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(AppDimensions.radiusL),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
