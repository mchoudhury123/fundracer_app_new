import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import '../widgets/screen_layout.dart';
import 'dart:async';  // Add Timer import
import 'email_auth_screen.dart';  // Add import for EmailAuthScreen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _slides = [
    {
      'title': '*** TEST SLIDE ***\nSLIDE 1 of 5\nWAIT 3 SECONDS',
      'subtitle': 'This is a test slide - swipe or wait',
      'image': 'assets/images/running_vector.png',
    },
    {
      'title': 'MAKE YOUR MILES\nCOUNT FOR A\nGOOD CAUSE',
      'subtitle': 'Start making a difference',
      'image': 'assets/images/running_vector.png',
    },
    {
      'title': 'TRANSFORM YOUR\nRUNS INTO\nDONATIONS',
      'subtitle': 'Every step counts',
      'image': 'assets/images/running_vector.png',
    },
    {
      'title': 'JOIN A COMMUNITY\nOF IMPACT\nRUNNERS',
      'subtitle': 'Run together, change together',
      'image': 'assets/images/running_vector.png',
    },
    {
      'title': 'TRACK YOUR\nCHARITABLE\nIMPACT',
      'subtitle': 'See your difference grow',
      'image': 'assets/images/running_vector.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start the timer when the screen initializes
    _startTimer();
  }

  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _handlePhoneSignIn() {
    // TODO: Implement phone sign in
  }

  void _handleEmailSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailAuthScreen()),
    );
  }

  void _handleAltSignIn() {
    // TODO: Implement alternative sign in
  }

  void _handleTermsClick() {
    // TODO: Navigate to terms screen
  }

  void _handlePrivacyClick() {
    // TODO: Navigate to privacy screen
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
                // Reset timer when page is manually changed
                _startTimer();
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTapDown: (_) {
                    _timer?.cancel();  // Pause timer when user taps
                  },
                  onTapUp: (_) {
                    _startTimer();  // Resume timer when user releases
                  },
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _slides[index]['title']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: size.height * 0.35,
                          child: Image.asset(
                            _slides[index]['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          _slides[index]['subtitle']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Page indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length, // Use actual number of slides
              (index) => Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Color(0xFF7DF9FF)
                      : Color(0xFF7DF9FF).withOpacity(0.3),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Color(0xFF7DF9FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleEmailSignIn,
                        borderRadius: BorderRadius.circular(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              color: Color(0xFF7DF9FF),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Sign in with Email',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sign in with',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialIconButton(Icons.apple),
                      _buildSocialIconButton(Icons.android),
                      _buildSocialIconButton(Icons.facebook),
                      _buildSocialIconButton(Icons.mail_outline),
                    ],
                  ),
                  SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        TextSpan(text: 'By signing up you are agreeing to the '),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIconButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 24,
          color: Colors.black87,
        ),
      ),
    );
  }
} 