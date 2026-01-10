import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DonateNowScreen extends StatefulWidget {
  const DonateNowScreen({super.key});

  @override
  State<DonateNowScreen> createState() => _DonateNowScreenState();
}

class _DonateNowScreenState extends State<DonateNowScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                   GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: AppTheme.headerGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Donate Now",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44), // Balance
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    "Your small contribution can create a big impact",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textDark,
                      height: 1.4,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5), // Light Grey
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Purpose of Donation",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Fake Input / Select
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Text(
                            "Select",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Checkbox Agreement
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24, width: 24,
                              child: Checkbox(
                                value: _isAgreed, 
                                activeColor: AppTheme.darkGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) {
                                  setState(() {
                                    _isAgreed = val ?? false;
                                  });
                                }
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "I agree that my donation will be used for social and community support purposes.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textDark,
                                  height: 1.3
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const Spacer(),

            // Footer Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppTheme.headerGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.darkGreen.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ]
                ),
                child: ElevatedButton(
                  onPressed: () {
                     // Placeholder action
                     Navigator.pop(context); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                       Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
