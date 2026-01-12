import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lead_generation/core/constants/app_colors.dart';
import 'package:lead_generation/core/theme/app_theme.dart';
import 'package:lead_generation/features/auth/registration/screen/register_screen.dart';
import 'package:lead_generation/features/auth/repository/auth_repository.dart';
import 'package:lead_generation/features/home/home_screen.dart';
import '../../../../core/storage/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isOtpSent = false;
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;
  String? _receivedToken;

  @override
  void dispose() {
    _mobileController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.login(
        contactNo: _mobileController.text,
      );

      if (mounted) {
        setState(() {
          _isOtpSent = true;
          _isLoading = false;
          // Store token from login response if present (normalized by ApiClient)
          if (response != null && response['token'] != null) {
            _receivedToken = response['token'];
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: $e')),
        );
      }
    }
  }

  Future<void> _handleLogin() async {
    final otpString = _otpControllers.map((c) => c.text).join();
    if (otpString.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a complete 4-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.verifyOtp(
        contactNo: _mobileController.text,
        otp: otpString,
      );

      // Check for token (ApiClient already normalizes most cases into 'token')
      String? token;
      if (response != null && response['token'] != null) {
        token = response['token'];
      }

      // Fallback to token received during initial login call
      token ??= _receivedToken;

      if (token != null) {
        await _storageService.saveToken(token);
        
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        throw 'Missing token in response: ${response.toString()}';
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
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
              height: 250.h, 
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          
          // Main Content Card
          Positioned(
            top: 230.h,  
            left: 0, 
            right: 0,
            bottom: 0, 
            child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 20.h),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 500.w,
                      height: 120.h, 
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Login',
                      style: GoogleFonts.manrope(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700, 
                        color: AppColors.primaryGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Enter Your Mobile Number To\nReceive OTP',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp, 
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Mobile Number Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mobile No',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    
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
                          fontSize: 13.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5.w),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 10.h),
                    
                    // OTP Section (Only visible when _isOtpSent is true)
                    if (_isOtpSent) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'OTP',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 129, 128, 128),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) => _otpTextField(context, _otpControllers[index]),),
                      ),
                       SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                                style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13.sp),
                                children: [
                                  const TextSpan(text: "Didn't Received ? "),
                                  TextSpan(
                                    text: 'Resend',
                                    style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()..onTap = () => _handleVerify(),
                                  ),
                                ]),
                          ),
                        ),
                       SizedBox(height: 10.h),
                    ],

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24.r),
        color: AppColors.backgroundGrey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Register Link
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontSize: 14.sp,
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
            SizedBox(height: 20.h),

            // Verify / Login Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.headerGradient,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _isOtpSent ? _handleLogin() : _handleVerify(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: _isLoading 
                  ? SizedBox(width: 20.w, height: 20.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : Text(
                  _isOtpSent ? 'Login' : 'Verify',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
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
  
  Widget _otpTextField(BuildContext context, TextEditingController controller) {
    return SizedBox(
      width: (1.sw - 90.w) / 4,
      height: 45.h,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
          if (value.isEmpty) FocusScope.of(context).previousFocus();
        },
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18.sp),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Color.fromARGB(255, 207, 206, 206))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Color.fromARGB(255, 211, 209, 209))), 
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5.w)),
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
