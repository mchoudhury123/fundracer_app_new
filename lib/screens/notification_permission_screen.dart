import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'charity_partners_screen.dart';

class NotificationPermissionScreen extends StatefulWidget {
  final String healthAppName;

  const NotificationPermissionScreen({
    super.key,
    required this.healthAppName,
  });

  @override
  State<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends State<NotificationPermissionScreen> {
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _saveNotificationPreference(bool enabled) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (enabled) {
          // Request notification permission if user wants notifications
          final status = await Permission.notification.request();
          if (status.isDenied) {
            throw Exception('Notification permission denied');
          }
        }

        // Save preference to Firestore regardless of permission status
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'notificationsEnabled': enabled,
          'notificationPreferenceSetAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          setState(() {
            _statusMessage = enabled 
                ? 'Notifications enabled successfully!'
                : 'Preference saved. You can enable notifications later in settings.';
          });
        }

        // TODO: Navigate to the next screen after a brief delay
        // await Future.delayed(const Duration(seconds: 2));
        // if (mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const NextScreen(),
        //     ),
        //   );
        // }
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to save preference. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Congratulations\nare ready to\nmake a difference',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your ${widget.healthAppName} is connected.\n\nWould you like us to send reminders to log into FundRacer so you can log your miles?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      size: 48,
                      color: Color(0xFF4A67FF),
                    ),
                    const SizedBox(height: 24),
                    if (_statusMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _statusMessage.contains('successfully')
                                ? Colors.green
                                : _statusMessage.contains('Failed')
                                    ? Colors.red
                                    : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _saveNotificationPreference(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A67FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Yes, Enable Notifications',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: _isLoading ? null : () => _saveNotificationPreference(false),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF4A67FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'No, Maybe Later',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_statusMessage.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CharityPartnersScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A67FF),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
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