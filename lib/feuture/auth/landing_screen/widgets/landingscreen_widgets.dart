import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lead_generation/feuture/auth/registration/screen/register_screen.dart';

// Make sure to adjust this path if your folder structure is different
import '../../../../core/constants/app_colors.dart';
// ========= ADD THIS IMPORT FOR THE LOGIN SCREEN =========
import '../../login/screen/login_screen.dart';
// =========================================================

/// The top hero image section with the collage and decorative sparkles.
class LandingHeroImage extends StatelessWidget {
  const LandingHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/landing_hero.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// The main headline text for the landing screen.
class HeadlineText extends StatelessWidget {
  const HeadlineText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: GoogleFonts.montserratAlternates(
          fontSize: 27.75,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
          height: 1.3,
          letterSpacing: 0.0,
        ),
        children: const <TextSpan>[
          TextSpan(text: 'Your '),
          TextSpan(
            text: 'Trusted Platform',
            style: TextStyle(color: AppColors.primaryGreen),
          ),
          TextSpan(text: '\nFor Community\nSupport & Empowerment'),
        ],
      ),
    );
  }
}

/// The "Register Now" and "Login" buttons.
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 2,
              shadowColor: AppColors.primaryGreen.withOpacity(0.4),
            ),
            child: Text(
              'Register Now',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: OutlinedButton(
            // ========= UPDATE THIS onPressed CALLBACK =========
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            // =================================================
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.lightGreen,
              foregroundColor: AppColors.primaryGreen,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

/// The terms and conditions checkbox and text.
class TermsAndConditionsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsAndConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
            checkColor: AppColors.white,
            side: BorderSide(color: Colors.grey.shade300, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        const Flexible(
          child: Text(
            'By Continuing, You Agree To Our Terms &\nPrivacy Policy',
            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ),
      ],
    );
  }
}