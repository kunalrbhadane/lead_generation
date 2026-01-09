import 'package:flutter/material.dart';
import 'package:lead_generation/feuture/auth/landing_screen/widgets/landingscreen_widgets.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // =======================================================
            // === THIS IS THE UPDATED IMAGE CONTAINER SECTION     ===
            // =======================================================
            // The container that allocates the top 50% of the screen height.
            SizedBox(
              height: size.height * 0.5,
              // We use a Stack to allow for precise positioning of the image.
              child: Stack(
                // This is crucial to allow the image to "bleed" outside the bounds
                // of the SizedBox without being cut off.
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    // Apply the precise positioning from your design specs
                    top: -35,
                    left: -36,
                    child: SizedBox(
                      // Apply the exact width and height
                      width: 459,
                      height: 470,
                      // Our clean, reusable widget goes inside
                      child: const LandingHeroImage(),
                    ),
                  ),
                ],
              ),
            ),
            // =======================================================
            // =======================================================

            // Bottom part takes the remaining space on the screen
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HeadlineText(),
                    const ActionButtons(),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}