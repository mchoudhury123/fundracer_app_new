import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/strava_service.dart';
import 'profile_screen.dart';
import 'run_tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _steps = 0;
  double _totalDistance = 0;
  int _totalRuns = 0;
  Health? _health;
  bool _isLoading = true;
  late StravaService _stravaService;
  bool _isStravaConnected = false;

  final List<Map<String, dynamic>> _stories = [
    {
      'color': Color(0xFFFF9838),
      'title': 'Daily Goal',
      'subtitle': '10,000 steps'
    },
    {
      'color': Color(0xFF4CAF50),
      'title': 'New 🎉',
      'subtitle': 'Weekly Challenge'
    },
    {
      'color': Color(0xFF2196F3),
      'title': 'Podcast',
      'subtitle': 'Running Tips'
    },
    {
      'color': Color(0xFFE91E63),
      'title': 'New 🎉',
      'subtitle': 'Achievement'
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _stravaService = StravaService(prefs);
    
    if (!kIsWeb) {
      _health = Health();
    }
    
    await _requestPermissionsAndFetchData();
    await _checkStravaConnection();
  }

  Future<void> _checkStravaConnection() async {
    final isAuthenticated = await _stravaService.isAuthenticated;
    setState(() {
      _isStravaConnected = isAuthenticated;
    });
    if (isAuthenticated) {
      await _fetchStravaData();
    }
  }

  Future<void> _fetchStravaData() async {
    try {
      final stats = await _stravaService.getAthleteStats();
      setState(() {
        _totalDistance = (stats['total_distance'] as num).toDouble() / 1000; // Convert to km
        _totalRuns = stats['total_runs'] as int;
      });
    } catch (e) {
      print('Error fetching Strava data: $e');
    }
  }

  Future<void> _connectStrava() async {
    try {
      await _stravaService.authenticate();
      await _checkStravaConnection();
    } catch (e) {
      print('Error connecting to Strava: $e');
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to connect to Strava. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _requestPermissionsAndFetchData() async {
    if (kIsWeb) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Request activity recognition permission on Android
    if (!Platform.isIOS) {
      final status = await Permission.activityRecognition.request();
      if (status.isDenied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // Get steps for today
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      // Request authorization
      final authorized = await _health?.hasPermissions([HealthDataType.STEPS]) ?? false;

      if (authorized) {
        // Fetch steps
        final healthData = await _health?.getHealthDataFromTypes(
          startTime: midnight,
          endTime: now,
          types: [HealthDataType.STEPS],
        );
        
        if (healthData != null && healthData.isNotEmpty) {
          final totalSteps = healthData
              .map((e) => num.tryParse(e.value.toString()) ?? 0)
              .fold<int>(0, (sum, value) => sum + value.toInt());
              
          setState(() {
            _steps = totalSteps;
            _isLoading = false;
          });
        }
      } else {
        final granted = await _health?.requestAuthorization([HealthDataType.STEPS]) ?? false;
        if (granted) {
          await _requestPermissionsAndFetchData();
        }
      }
    } catch (e) {
      debugPrint('Error fetching steps: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const phoneWidth = 393.0;
    const phoneHeight = 852.0;
    const backgroundColor = Colors.white;

    Widget mainContent = Container(
      width: phoneWidth,
      height: phoneHeight,
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildStoryList(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatsCard(),
                    _buildShareButton(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigationBar(),
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
              color: backgroundColor,
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
      backgroundColor: backgroundColor,
      body: mainContent,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        '(RED)',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                FirebaseAuth.instance.currentUser?.photoURL ?? 
                'https://via.placeholder.com/40',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryList() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: story['color'] as Color,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (story['subtitle'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      story['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            _steps.toString(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: -1,
                            ),
                          ),
                    const SizedBox(height: 8),
                    const Text(
                      'STEPS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isStravaConnected) ...[
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _totalDistance.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'KM RUN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: _steps / 10000,
            backgroundColor: Colors.grey[200],
            color: Colors.grey,
            minHeight: 8,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 20),
          if (!_isStravaConnected)
            ElevatedButton.icon(
              onPressed: _connectStrava,
              icon: const Icon(
                Icons.directions_run,
                size: 24,
                color: Colors.white,
              ),
              label: const Text('Connect Strava'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC4C02),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            Text(
              '$_totalRuns Total Runs',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.handshake_outlined,
                color: Color(0xFF4CAF50),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Easy Share',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            IconButton(
              onPressed: () => setState(() => _selectedIndex = 0),
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                color: _selectedIndex == 0 ? const Color(0xFF4A67FF) : Colors.grey,
                size: 28,
              ),
            ),
            // Start Run Button (Center)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A67FF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A67FF).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RunTrackingScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.directions_run,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            // Charity Info Button
            IconButton(
              onPressed: () => setState(() => _selectedIndex = 2),
              icon: Icon(
                _selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline,
                color: _selectedIndex == 2 ? const Color(0xFF4A67FF) : Colors.grey,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 