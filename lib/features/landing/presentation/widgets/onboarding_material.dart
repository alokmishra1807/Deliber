// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:deliber/core/error/design/gradientButton.dart';
import 'package:flutter/material.dart';

class OnboardingMaterial extends StatefulWidget {
  final String header;
  final String subHeader1;
  final String subHeader2;
  final String buttonText;
  final String imagePath;
  final VoidCallback onPressed;
  const OnboardingMaterial({
    Key? key,
    required this.header,
    required this.subHeader1,
    required this.subHeader2,
    required this.buttonText,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<OnboardingMaterial> createState() => _OnboardingMaterialState();
}

class _OnboardingMaterialState extends State<OnboardingMaterial> {
  _OnboardingMaterialState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 30.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                const SizedBox(height: 40),
                Image.asset(widget.imagePath),
                const SizedBox(height: 40),
                Text(
                  widget.header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.subHeader1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.subHeader2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                StylishButton(
                  text: widget.buttonText,
                  onPressed: widget.onPressed,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
