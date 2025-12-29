import 'package:deliber/features/landing/presentation/bloc/onboarding_bloc.dart';
import 'package:deliber/features/landing/presentation/widgets/onboarding_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      
      context.read<OnboardingBloc>().add(FinishOnboarding());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          OnboardingMaterial(
            header: 'Welcome to Deliber',
            subHeader1: 'Send and Receive Parcels Effortlessly with Doorstep Pickup',
            subHeader2: 'Fast, secure, and reliable',
            buttonText: 'Next',
            imagePath: 'assets/images/on2.png',
            onPressed: _nextPage,
          ),
          OnboardingMaterial(
            header: 'Track Every Move',
            subHeader1: 'Know where your parcel is at all times',
            subHeader2: 'Live tracking updates from pickup to delivery',
            buttonText: 'Next',
            imagePath: 'assets/images/on3.png',
            onPressed: _nextPage,
          ),
          OnboardingMaterial(
            header: 'Get Started',
            subHeader1: 'All your parcel needs in one app',
            subHeader2: 'Let’s go!',
            buttonText: 'Get Started',
            imagePath: 'assets/images/on1.png',
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }
}
