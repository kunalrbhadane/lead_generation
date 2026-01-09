import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/constants/app_colors.dart';
import '../../registration/screen/register_screen.dart';

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
      backgroundColor: AppColors.primaryGreen,
      body: Stack(
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
            top: 227, 
            left: 0, 
            right: 0,
            bottom: 0, 
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 80, 
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Login',
                      style: GoogleFonts.manrope(
                        fontSize: 25,
                        fontWeight: FontWeight.w700, 
                        color: AppColors.primaryGreen,
                        height: 1.0, 
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter Your Mobile Number To\nReceive OTP',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14, 
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 25),

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
                    const SizedBox(height: 8),
                    
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
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                    
                    const SizedBox(height: 20),
                    
                    // OTP Section (Only visible when _isOtpSent is true)
                    if (_isOtpSent) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'OTP',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) => _otpTextField(context)),
                      ),
                       const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
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
                      const SizedBox(height: 24),
                    ],

                    const SizedBox(height: 20),

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
                    // Text changes dynamically based on state
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_isOtpSent) {
                            setState(() {
                              _isOtpSent = true;
                            });
                          } else {
                            // Perform Auth
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _isOtpSent ? 'Login' : 'Verify', // Dynamic Text
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  
    Widget _otpTextField(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 90) / 6,
      height: 50,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.textGrey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.textGrey)), 
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
