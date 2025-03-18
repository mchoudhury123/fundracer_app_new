import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import 'notification_permission_screen.dart';

class ConnectHealthScreen extends StatefulWidget {
  const ConnectHealthScreen({super.key});

  @override
  State<ConnectHealthScreen> createState() => _ConnectHealthScreenState();
}

class _ConnectHealthScreenState extends State<ConnectHealthScreen> {
  bool _isLoading = false;
  String _statusMessage = '';
  String? _selectedApp;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  final List<Map<String, dynamic>> healthApps = [
    {
      'name': 'Strava',
      'icon': Icons.directions_bike,
      'description': 'Connect with your Strava account to track your runs and rides',
    },
    {
      'name': 'Garmin',
      'icon': Icons.watch,
      'description': 'Sync your Garmin device data to track your activities',
    },
    {
      'name': 'Google Fit',
      'icon': Icons.fitness_center,
      'description': 'Use Google Fit to track your daily activities and workouts',
    },
    {
      'name': 'Apple Health',
      'icon': Icons.favorite,
      'description': 'Connect to Apple Health to track your steps and workouts',
      'platform': 'ios',
    },
  ];
  
  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveHealthConnectionStatus(String appName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'healthAppConnected': true,
        'healthAppName': appName,
        'healthConnectedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _requestHealthPermissions(String appName) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Connecting to $appName...';
      _selectedApp = appName;
    });

    try {
      // Save to Firestore that health is connected
      await _saveHealthConnectionStatus(appName);

      // Show success message briefly before navigating
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPermissionScreen(
              healthAppName: appName,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to connect to $appName. Please try again.';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Connect Your\nFitness App',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose how you would like to connect and track your activities. This helps us convert your miles into charitable donations.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.separated(
                  itemCount: healthApps.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final app = healthApps[index];
                    final bool isSelected = _selectedApp == app['name'];
                    
                    // Skip Apple Health on non-iOS devices
                    if (app['platform'] == 'ios' && !Platform.isIOS) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF4A67FF) : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isLoading ? null : () => _requestHealthPermissions(app['name']),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4A67FF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    app['icon'],
                                    color: const Color(0xFF4A67FF),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        app['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        app['description'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected && _isLoading)
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A67FF)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_statusMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _statusMessage.contains('Successfully')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
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