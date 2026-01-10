import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../login/screen/login_screen.dart';
import '../widgets/register_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  int _selectedCategoryIndex = -1;

  List<Widget> _pages = [];
  List<Map<String, dynamic>> _stepData = [];

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _buildInitialFlow();

    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  void _buildInitialFlow() {
    setState(() {
      _selectedCategoryIndex = -1;
      _pages = [
        const PersonalInfoForm(),
        SelectCategoryForm(
          onSelectionChanged: (selectedIndex) {
            setState(() => _selectedCategoryIndex = selectedIndex);
          },
        ),
      ];
      _stepData = [
        {'step': 'Step 1 of 4', 'progress': 0.17},
        {'step': 'Step 2 of 3', 'progress': 0.30},
      ];
    });
  }

  void _updateRegistrationFlow() {
    List<Widget> updatedPages = [_pages[0], _pages[1]];
    
    switch (_selectedCategoryIndex) {
      case 0: // Student
        updatedPages.addAll([const QualificationDetailsForm(), const DocumentUploadForm()]);
        break;
      case 1: // Professionals
        updatedPages.add(const CompanyDetailsForm());
        break;
      case 2: // Business
        updatedPages.add(const BusinessDetailsForm());
        break;
      case 3: // Others
        updatedPages.add(const OtherDetailsForm());
        break;
      default: return;
    }

    setState(() {
      _pages = updatedPages;
      _generateStepData();
    });
  }

  void _generateStepData() {
    final totalSteps = _pages.length;
    _stepData = List.generate(totalSteps, (index) {
      return {'step': 'Step ${index + 1} of $totalSteps', 'progress': (index + 1) / totalSteps};
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage == 1) {
      _updateRegistrationFlow();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      });
      return;
    }
    
    if (_currentPage == _pages.length - 1) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const RegistrationSuccessScreen()), (route) => false);
    } else {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  bool get isContinueButtonEnabled {
    if (_currentPage == 1) {
      return _selectedCategoryIndex != -1;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = _stepData.isNotEmpty && _currentPage < _stepData.length
        ? _stepData[_currentPage]
        : {'step': 'Step 1 of 4', 'progress': 0.17};

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryGreen,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (_currentPage == 0) {
                  Navigator.of(context).pop();
                } else {
                  _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              },
            ),
          ),
        ),
        title: Text('Register', style: GoogleFonts.poppins(color: AppColors.textDark, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            children: [
              ProgressHeader(step: currentStepData['step'], progress: currentStepData['progress']),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: _pages,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.white,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: isContinueButtonEnabled ? _goToNextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: isContinueButtonEnabled ? Colors.white : Colors.grey.shade600)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16, color: isContinueButtonEnabled ? Colors.white : Colors.grey.shade600),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                CircleAvatar(radius: 60, backgroundColor: AppColors.lightGreen, child: const CircleAvatar(radius: 50, backgroundColor: AppColors.primaryGreen, child: Icon(Icons.check, color: Colors.white, size: 60))),
                const SizedBox(height: 32),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    children: const <TextSpan>[
                      TextSpan(text: 'Registeration\n'),
                      TextSpan(text: 'Successfull !!', style: TextStyle(color: AppColors.primaryGreen)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Your Registeration request has been received. Our team will review it shortly.', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGrey)),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.headerGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login To Continue', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}