import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const CustomTextFormField({
    super.key, 
    required this.label, 
    required this.hint, 
    this.isDropdown = false, 
    this.isMultiLine = false, 
    this.controller, 
    this.readOnly = false, 
    this.onTap,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.maxLength,
  });

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
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            validator: validator,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            maxLines: isMultiLine ? 4 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withOpacity(0.7), fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              counterText: '',
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
  final Function() onTap;
  final String? selectedFileName;

  const FileUploadField({super.key, required this.label, this.hint = 'Upload', required this.onTap, this.selectedFileName});

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
            readOnly: true,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: selectedFileName ?? hint,
              hintStyle: GoogleFonts.poppins(
                color: selectedFileName != null ? AppColors.textDark : AppColors.textGrey.withOpacity(0.7), 
                fontSize: 13
              ),
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
  final Map<String, TextEditingController> controllers;
  final VoidCallback? onProfileImageTap;
  final File? profileImage;
  final VoidCallback? onDateOfBirthTap;
  final GlobalKey<FormState> formKey;
  
  const PersonalInfoForm({
    super.key, 
    required this.controllers, 
    this.onProfileImageTap, 
    this.profileImage, 
    this.onDateOfBirthTap,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal Information', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: onProfileImageTap,
                  child: CircleAvatar(
                    radius: 40, 
                    backgroundColor: Colors.white, 
                    backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                    child: profileImage == null ? Icon(Icons.camera_alt, size: 30, color: Colors.grey.shade400) : null
                  ),
                ),
              ),

              const SizedBox(height: 24),
              CustomTextFormField(
                label: 'Full Name', 
                hint: 'Enter your name', 
                controller: controllers['FullName'],
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),

              CustomTextFormField(
                label: 'Contact No', 
                hint: 'Enter your contact no', 
                controller: controllers['ContactNo'],
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Contact no is required';
                  if (value.length != 10) return 'Enter valid 10 digit number';
                  return null;
                },
              ),

              CustomTextFormField(
                label: 'Email', 
                hint: 'Enter your email', 
                controller: controllers['Email'],
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter valid email';
                  return null;
                },
              ),

              CustomTextFormField(
                label: 'Date of Birth', 
                hint: 'Select Date', 
                controller: controllers['DateofBirth'], 
                readOnly: true, 
                onTap: onDateOfBirthTap,
                validator: (value) => value == null || value.isEmpty ? 'Date of Birth is required' : null,
              ),

              const CustomTextFormField(label: 'Gender', hint: 'Select', isDropdown: true),
              CustomTextFormField(
                label: 'Whatsapp contact no', 
                hint: 'Enter you contact no',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              CustomTextFormField(label: 'State', hint: 'Select', isDropdown: true, controller: controllers['State']),

              CustomTextFormField(label: 'City', hint: 'Enter your city', controller: controllers['City']),

              CustomTextFormField(label: 'Caste', hint: 'Select', isDropdown: true, controller: controllers['Caste']),

              const CustomTextFormField(label: 'About Description (Optional)', hint: 'Enter about yourself', isMultiLine: true),
            ],
          ),
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
  final int? initialIndex;

  const SelectCategoryForm({
    super.key,
    required this.onSelectionChanged,
    this.initialIndex,
  });

  @override
  State<SelectCategoryForm> createState() => _SelectCategoryFormState();
}

class _SelectCategoryFormState extends State<SelectCategoryForm> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(SelectCategoryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

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
  final Map<String, TextEditingController> controllers;
  const CompanyDetailsForm({super.key, required this.controllers});

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
            CustomTextFormField(label: 'Job Title', hint: 'Enter', controller: controllers['JobTitle']),
            CustomTextFormField(label: 'Company Name', hint: 'Enter', controller: controllers['CompanyName']),
            CustomTextFormField(label: 'Total Experience', hint: 'Enter', controller: controllers['TotalExperience']),
          ],
        ),
      ),
    );
  }
}

class BusinessDetailsForm extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  const BusinessDetailsForm({super.key, required this.controllers});

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
            CustomTextFormField(label: 'Business Name', hint: 'Enter', controller: controllers['BusinessName']),
            CustomTextFormField(label: 'Services', hint: 'Enter', controller: controllers['Services']),
            CustomTextFormField(label: 'Place', hint: 'Enter', controller: controllers['Place']),
          ],
        ),
      ),
    );
  }
}

// -- Final Step Widgets --

class QualificationDetailsForm extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final VoidCallback? onMarksheetTap;
  final String? marksheetFileName;

  const QualificationDetailsForm({super.key, required this.controllers, this.onMarksheetTap, this.marksheetFileName});

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
            CustomTextFormField(label: 'Current Qualification', hint: 'Select', isDropdown: true, controller: controllers['CurrentQualification']),
            CustomTextFormField(label: 'Field of Study', hint: 'Select', isDropdown: true, controller: controllers['FieldofStudy']),
            CustomTextFormField(label: 'Current Status', hint: 'Select', isDropdown: true, controller: controllers['CurrentStatus']),
            CustomTextFormField(label: 'Institute', hint: 'Select', isDropdown: true, controller: controllers['Institute']),
            FileUploadField(label: 'Marksheet', onTap: onMarksheetTap ?? () {}, selectedFileName: marksheetFileName),
          ],
        ),
      ),
    );
  }
}

class DocumentUploadForm extends StatefulWidget {
  final VoidCallback? onAdhaarTap;
  final String? adhaarFileName;
  final VoidCallback? onOBCTap;
  final String? obcFileName;

  const DocumentUploadForm({
    super.key, 
    this.onAdhaarTap, 
    this.adhaarFileName, 
    this.onOBCTap, 
    this.obcFileName,
  });

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
            FileUploadField(label: 'Adhaar Card', onTap: widget.onAdhaarTap ?? () {}, selectedFileName: widget.adhaarFileName),
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
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FileUploadField(label: '', hint: 'Upload OBC Certificate', onTap: widget.onOBCTap ?? () {}, selectedFileName: widget.obcFileName),
              ),
          ],
        ),
      ),
    );
  }
}

class OtherDetailsForm extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  const OtherDetailsForm({super.key, required this.controllers});

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
            CustomTextFormField(label: 'Note', hint: 'Enter your note here...', isMultiLine: true, controller: controllers['Notes']),
          ],
        ),
      ),
    );
  }
}