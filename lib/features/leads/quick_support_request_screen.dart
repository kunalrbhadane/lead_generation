import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class QuickSupportRequestScreen extends StatefulWidget {
  const QuickSupportRequestScreen({super.key});

  @override
  State<QuickSupportRequestScreen> createState() => _QuickSupportRequestScreenState();
}

class _QuickSupportRequestScreenState extends State<QuickSupportRequestScreen> {
  String? _selectedSupportType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
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
                              "Quick Support Request",
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
                    
                    const SizedBox(height: 30),

                    // Form Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5), // Light grey bg
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            "Type of support required",
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold, 
                              color: AppTheme.textDark
                            ),
                          ),
                          
                          const SizedBox(height: 15),

                          // Dropdown Label
                          const Text(
                            "Support Required",
                            style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                          ),
                          const SizedBox(height: 8),
                          
                          // Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSupportType,
                                hint: const Text("Select", style: TextStyle(color: Colors.grey)),
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.darkGreen),
                                items: <String>['Education', 'Medical', 'Other'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedSupportType = newValue;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Add Note Label
                          const Text(
                            "Add Note",
                            style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                          ),
                          const SizedBox(height: 8),

                          // Text Field
                          Container(
                            height: 150,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                             decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const TextField(
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add about yourself or any special note",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Submit Button
                    Container(
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
                    const SizedBox(height: 20),
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
