import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'bank_card_screen.dart';

class ConfirmCharityScreen extends StatelessWidget {
  final String charityName;
  final Color charityColor;

  const ConfirmCharityScreen({
    super.key,
    required this.charityName,
    required this.charityColor,
  });

  String get charityDescription {
    // Placeholder descriptions for each charity
    final descriptions = {
      'The Michael J. Fox Foundation': 'Dedicated to finding a cure for Parkinson\'s disease through research funding and ensuring the development of improved therapies.',
      'Habitat for Humanity': 'Building strength, stability and self-reliance through shelter, helping families achieve decent and affordable housing.',
      'Feeding America': 'The nation\'s largest domestic hunger-relief organization, working to connect people with food and end hunger.',
      'The Leukemia & Lymphoma Society': 'Fighting blood cancer through research, education and patient services, funding lifesaving blood cancer research.',
      'The Nature Conservancy': 'Working to create a world where people and nature can thrive together, protecting lands and waters worldwide.',
      'Every Mother Counts': 'Making pregnancy and childbirth safe for every mother, everywhere, through advocacy and direct support.',
      'She\'s The First': 'Fighting gender inequality through education, supporting girls who will be first in their families to graduate high school.',
      '(RED)': 'Fighting to end AIDS, tuberculosis and malaria through partnerships and innovative fundraising campaigns.',
      'Epilepsy Foundation of America': 'Leading the fight to overcome the challenges of living with epilepsy and accelerate therapies to stop seizures.',
    };
    return descriptions[charityName] ?? 'Description not available';
  }

  @override
  Widget build(BuildContext context) {
    const phoneWidth = 393.0;
    const phoneHeight = 852.0;

    Widget mainContent = Container(
      width: phoneWidth,
      height: phoneHeight,
      color: const Color(0xFF4A67FF),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Confirm Charity',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: charityColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: charityColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      charityName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      charityDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A67FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Color(0xFF4A67FF),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  'Verified Partner',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A67FF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This charity has been verified by our team and meets our standards for transparency and impact.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BankCardScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4A67FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Confirm Selection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: phoneWidth,
            height: phoneHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: mainContent,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF4A67FF),
      body: mainContent,
    );
  }
} 