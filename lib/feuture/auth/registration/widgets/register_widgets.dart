import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

// -- Common Widgets --

class ProgressHeader extends StatelessWidget {
  final String step;
  final double progress; // 0.0 to 1.0

  const ProgressHeader({super.key, required this.step, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(step, style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14)),
              Text('${(progress * 100).toInt()}%', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.borderGrey,
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isDropdown;
  final bool isMultiLine;

  const CustomTextFormField({super.key, required this.label, required this.hint, this.isDropdown = false, this.isMultiLine = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: isMultiLine ? 4 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withOpacity(0.7)),
              filled: true,
              fillColor: AppColors.backgroundGrey,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class FileUploadField extends StatelessWidget {
  final String label;
  final String hint;

  const FileUploadField({super.key, required this.label, this.hint = 'Upload'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withOpacity(0.7)),
              filled: true,
              fillColor: AppColors.backgroundGrey,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderGrey, style: BorderStyle.solid, width: 1.5),
              ),
              suffixIcon: const Icon(Icons.file_upload_outlined, color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}

// -- Widgets for Step 1: Personal Information --

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.formBackground, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            Center(child: CircleAvatar(radius: 50, backgroundColor: AppColors.backgroundGrey, child: Icon(Icons.camera_alt, size: 40, color: Colors.grey.shade400))),
            const SizedBox(height: 24),
            const CustomTextFormField(label: 'Full Name', hint: 'Enter your name'),
            const CustomTextFormField(label: 'Contact No', hint: 'Enter your contact no'),
            const CustomTextFormField(label: 'Gender', hint: 'Select', isDropdown: true),
            const CustomTextFormField(label: 'Age', hint: 'Enter your age'),
            const CustomTextFormField(label: 'Whatsapp contact no', hint: 'Enter you contact no'),
            const CustomTextFormField(label: 'State', hint: 'Select', isDropdown: true),
            const CustomTextFormField(label: 'City', hint: 'Enter your city'),
            const CustomTextFormField(label: 'Caste', hint: 'Select', isDropdown: true),
            const CustomTextFormField(label: 'About Description', hint: 'Enter about yourself', isMultiLine: true),
          ],
        ),
      ),
    );
  }
}

// -- Widgets for Step 2: Select Category --

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightGreen : AppColors.formBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey, width: isSelected ? 1.5 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 30),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}
class SelectCategoryForm extends StatefulWidget {
  final Function(int) onSelectionChanged;
  const SelectCategoryForm({super.key, required this.onSelectionChanged});

  @override
  State<SelectCategoryForm> createState() => _SelectCategoryFormState();
}

class _SelectCategoryFormState extends State<SelectCategoryForm> {
  int? _selectedIndex;
  bool _othersWasTapped = false;

  void _handleSelection(int index) {
    setState(() {
      _selectedIndex = index;
      // This flag is true only when the 'Others' button is specifically tapped.
      _othersWasTapped = (index == 3);
    });
    widget.onSelectionChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.formBackground, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Category', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isTablet = constraints.maxWidth > 600;
                  final int crossAxisCount = isTablet ? 4 : 2;
                  final double childAspectRatio = isTablet ? 1.0 : 1.2;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
                    children: [
                      CategoryCard(icon: Icons.school_outlined, label: 'Student', 
                        // Highlight if it's selected OR if 'Others' was tapped.
                        isSelected: _selectedIndex == 0 || _othersWasTapped, 
                        onTap: () => _handleSelection(0)),
                      CategoryCard(icon: Icons.people_outline, label: 'Professionals', 
                        isSelected: _selectedIndex == 1 || _othersWasTapped, 
                        onTap: () => _handleSelection(1)),
                      CategoryCard(icon: Icons.business_center_outlined, label: 'Business', 
                        isSelected: _selectedIndex == 2 || _othersWasTapped, 
                        onTap: () => _handleSelection(2)),
                      CategoryCard(icon: Icons.more_horiz, label: 'Others', 
                        // IMPORTANT: Only highlight if selected, and NOT if it was just tapped to highlight others.
                        isSelected: _selectedIndex == 3 && !_othersWasTapped, 
                        onTap: () => _handleSelection(3)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// -- Conditional Widgets --

class CompanyDetailsForm extends StatelessWidget {
  const CompanyDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.formBackground, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            const CustomTextFormField(label: 'Job Title', hint: 'Enter'),
            const CustomTextFormField(label: 'Company Name', hint: 'Enter'),
            const CustomTextFormField(label: 'Total Experience', hint: 'Enter'),
          ],
        ),
      ),
    );
  }
}

class BusinessDetailsForm extends StatelessWidget {
  const BusinessDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.formBackground, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            const CustomTextFormField(label: 'Business Name', hint: 'Enter'),
            const CustomTextFormField(label: 'Services', hint: 'Enter'),
            const CustomTextFormField(label: 'Place', hint: 'Enter'),
          ],
        ),
      ),
    );
  }
}

// -- Final Step Widgets --

class QualificationDetailsForm extends StatelessWidget {
  const QualificationDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.formBackground, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qualification Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            const CustomTextFormField(label: 'Current Qualification', hint: 'Select', isDropdown: true),
            const CustomTextFormField(label: 'Field of Study', hint: 'Select', isDropdown: true),
            const CustomTextFormField(label: 'Current Status', hint: 'Select', isDropdown: true),
            const CustomTextFormField(label: 'Institute', hint: 'Select', isDropdown: true),
            const FileUploadField(label: 'Marksheet'),
          ],
        ),
      ),
    );
  }
}

class DocumentUploadForm extends StatefulWidget {
  const DocumentUploadForm({super.key});

  @override
  State<DocumentUploadForm> createState() => _DocumentUploadFormState();
}

class _DocumentUploadFormState extends State<DocumentUploadForm> {
  bool? _hasOBCCertificate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.formBackground, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document Upload', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            const FileUploadField(label: 'Adhaar Card'),
            const SizedBox(height: 16),
            Text('Do You Have OBC Certificate ?', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<bool>(value: true, groupValue: _hasOBCCertificate, onChanged: (val) => setState(() => _hasOBCCertificate = val), activeColor: AppColors.primaryGreen),
                const Text('Yes'),
                const SizedBox(width: 20),
                Radio<bool>(value: false, groupValue: _hasOBCCertificate, onChanged: (val) => setState(() => _hasOBCCertificate = val), activeColor: AppColors.primaryGreen),
                const Text('No'),
              ],
            ),
            if (_hasOBCCertificate == true)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FileUploadField(label: '', hint: 'Upload OBC Certificate'),
              ),
          ],
        ),
      ),
    );
  }
}