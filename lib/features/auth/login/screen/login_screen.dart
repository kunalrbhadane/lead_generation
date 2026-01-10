import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_colors.dart';
import '../../registration/screen/register_screen.dart';
import '../../../../features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isOtpSent = false;
  final TextEditingController _mobileController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.headerGradient,
        ),
        child: Stack(
          children: [
            // Custom Grid Background
            Positioned(
              top: 0,
              left: 0,
              right: 0, 
              height: 250, 
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          
          // Main Content Card
          Positioned(
            top: 230,  
            left: 0, 
            right: 0,
            bottom: 0, 
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              decoration: const BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width:500,
                      height: 120, 
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Login',
                      style: GoogleFonts.manrope(
                        fontSize: 25,
                        fontWeight: FontWeight.w700, 
                        color: AppColors.primaryGreen,
                       // height: 1.0, 
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Enter Your Mobile Number To\nReceive OTP',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14, 
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Mobile Number Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mobile No',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    
                    // Mobile Input
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter Your 10 Digit Mobile No',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // OTP Section (Only visible when _isOtpSent is true)
                    if (_isOtpSent) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'OTP',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 129, 128, 128),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) => _otpTextField(context),),
                      ),
                       const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                                style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13),
                                children: [
                                  const TextSpan(text: "Didn't Received ? "),
                                  TextSpan(
                                    text: 'Resend',
                                    style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                        ),
                       const SizedBox(height: 10),
                    ],

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        color: AppColors.backgroundGrey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Register Link
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
                children: [
                  const TextSpan(text: "Don't Have An Account ? "),
                  TextSpan(
                    text: 'Register',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Verify / Login Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.headerGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (!_isOtpSent) {
                    setState(() {
                      _isOtpSent = true;
                    });
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isOtpSent ? 'Login' : 'Verify',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
    Widget _otpTextField(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 90) / 6,
      height: 45,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
          if (value.isEmpty) FocusScope.of(context).previousFocus();
        },
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color.fromARGB(255, 207, 206, 206))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color.fromARGB(255, 211, 209, 209))), 
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5)),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Grid Spacing
    double step = size.width / 5; 

    // Vertical
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
