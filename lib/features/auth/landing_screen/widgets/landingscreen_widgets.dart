import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lead_generation/features/auth/registration/screen/register_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../login/screen/login_screen.dart';

/// The top hero image section with the collage and decorative sparkles.
class LandingHeroImage extends StatelessWidget {
  const LandingHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/landing_hero.png',
            fit: BoxFit.cover,
          ),
        ),
        // Gradient overlay for smoother transition to the content card
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.3),
                  Colors.white,
                ],
                stops: const [0.0, 0.7, 0.9, 1.0],
              ),
            ),
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
          fontSize: 28.sp, // Responsive font size
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
          height: 1.5,
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
          height: 56.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                elevation: 0,
              ),
              child: Text(
                'Register Now',
                style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 56.h,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.lightGreen,
              foregroundColor: AppColors.primaryGreen,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600),
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
          height: 24.h,
          width: 24.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
            checkColor: AppColors.white,
            side: BorderSide(color: Colors.grey.shade300, width: 2.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            'By Continuing, You Agree To Our Terms &\nPrivacy Policy',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textGrey),
          ),
        ),
      ],
    );
  }
}