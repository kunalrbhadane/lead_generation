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
              Text(step, style: GoogleFonts.poppins(color: AppColors.textDark, fontSize: 14)),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: isMultiLine ? 4 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withOpacity(0.7), fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
              hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withOpacity(0.7), fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent, width: 0),
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
        decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.camera_alt, size: 30, color: Colors.grey.shade400))),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 22),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark, fontSize: 13)),
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

  void _handleSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelectionChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Category', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isTablet = constraints.maxWidth > 600;
                  final int crossAxisCount = isTablet ? 4 : 2;
                  final double childAspectRatio = isTablet ? 2.2 : 3.0;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                    children: [
                      CategoryCard(icon: Icons.school_outlined, label: 'Student', 
                        isSelected: _selectedIndex == 0, 
                        onTap: () => _handleSelection(0)),
                      CategoryCard(icon: Icons.people_outline, label: 'Professionals', 
                        isSelected: _selectedIndex == 1, 
                        onTap: () => _handleSelection(1)),
                      CategoryCard(icon: Icons.business_center_outlined, label: 'Business', 
                        isSelected: _selectedIndex == 2, 
                        onTap: () => _handleSelection(2)),
                      CategoryCard(icon: Icons.more_horiz, label: 'Others', 
                        isSelected: _selectedIndex == 3, 
                        onTap: () => _handleSelection(3)),
                    ],
                  );
                },
              ),
            ],
          ),
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
        decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
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
        decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
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
        decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
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
        decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
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

class OtherDetailsForm extends StatelessWidget {
  const OtherDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Other Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 24),
            const CustomTextFormField(label: 'Note', hint: 'Enter your note here...', isMultiLine: true),
          ],
        ),
      ),
    );
  }
}