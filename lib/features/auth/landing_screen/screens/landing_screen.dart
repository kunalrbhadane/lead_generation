import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lead_generation/features/auth/landing_screen/widgets/landingscreen_widgets.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 0.5.sh, // 50% of screen height
              width: double.infinity,
              child: const LandingHeroImage(),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HeadlineText(),
                  SizedBox(height: 5.h), // Minimum gap
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ActionButtons(),
                      SizedBox(height: 8.h),
                      TermsAndConditionsCheckbox(
                        value: _agreedToTerms,
                        onChanged: (newValue) {
                          setState(() {
                            _agreedToTerms = newValue ?? false;
                          });
                        },
                      ),
                    ],
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