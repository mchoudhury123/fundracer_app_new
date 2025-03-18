import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const phoneWidth = 393.0;
    const phoneHeight = 852.0;

    Widget mainContent = Container(
      width: phoneWidth,
      height: phoneHeight,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement edit functionality
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            FirebaseAuth.instance.currentUser?.photoURL ?? 
                            'https://via.placeholder.com/120',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // Stats Section
            Container(
              margin: const EdgeInsets.all(24.0),
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '13.18',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TOTAL MILES',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[700],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '10',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TOTAL SESSIONS',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // History Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement daily view toggle
                    },
                    icon: const Text(
                      'Daily',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    label: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Graph Section
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: BarChartPainter(),
                ),
              ),
            ),
            // Activity Section
            Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.centerLeft,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ActivityItem(
                    miles: 1.62,
                    date: '03/01/2025',
                  ),
                ],
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
      backgroundColor: Colors.white,
      body: mainContent,
    );
  }
}

class ActivityItem extends StatelessWidget {
  final double miles;
  final String date;

  const ActivityItem({
    super.key,
    required this.miles,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFE51B23),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '(RED)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$miles miles did on $date',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE51B23)
      ..style = PaintingStyle.fill;

    // Sample data for the bars (normalized to fit the height)
    final data = [0.3, 0.2, 0.3, 0.2, 0.6, 0.8, 0.4];
    final barWidth = size.width / (data.length * 2);
    
    for (var i = 0; i < data.length; i++) {
      final barHeight = size.height * data[i];
      final left = i * (size.width / data.length) + (size.width / data.length - barWidth) / 2;
      
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 