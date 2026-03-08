import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

class LegalInfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalInfoScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Text(
          content,
          style: const TextStyle(height: 1.5),
        ),
      ),
    );
  }
}
