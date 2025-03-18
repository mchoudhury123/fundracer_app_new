import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'confirm_charity_screen.dart';

class CharityListScreen extends StatefulWidget {
  const CharityListScreen({super.key});

  @override
  State<CharityListScreen> createState() => _CharityListScreenState();
}

class _CharityListScreenState extends State<CharityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedCountry;

  final List<String> categories = [
    'Health',
    'Education',
    'Environmental',
    'Humanitarian',
    'Animal Welfare',
    'Children',
    'Arts',
    'International Aid',
  ];

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Global',
  ];

  final List<Map<String, dynamic>> charities = [
    {
      'name': 'The Michael J. Fox Foundation',
      'color': const Color(0xFFFF9838),
      'category': 'Health',
      'country': 'United States',
    },
    {
      'name': 'Habitat for Humanity',
      'color': const Color(0xFF8BC34A),
      'category': 'Humanitarian',
      'country': 'Global',
    },
    {
      'name': 'Feeding America',
      'color': const Color(0xFF556B2F),
      'category': 'Humanitarian',
      'country': 'United States',
    },
    {
      'name': 'The Leukemia & Lymphoma Society',
      'color': const Color(0xFFE53935),
      'category': 'Health',
      'country': 'United States',
    },
    {
      'name': 'The Nature Conservancy',
      'color': const Color(0xFF2E7D32),
      'category': 'Environmental',
      'country': 'Global',
    },
    {
      'name': 'Every Mother Counts',
      'color': const Color(0xFFFF5722),
      'category': 'Health',
      'country': 'Global',
    },
    {
      'name': 'She\'s The First',
      'color': const Color(0xFF26A69A),
      'category': 'Education',
      'country': 'Global',
    },
    {
      'name': '(RED)',
      'color': const Color(0xFFD32F2F),
      'category': 'Health',
      'country': 'Global',
    },
    {
      'name': 'Epilepsy Foundation of America',
      'color': const Color(0xFF673AB7),
      'category': 'Health',
      'country': 'United States',
    },
  ];

  List<Map<String, dynamic>> get filteredCharities => charities
      .where((charity) =>
          charity['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) &&
          (_selectedCategory == null ||
              charity['category'] == _selectedCategory) &&
          (_selectedCountry == null || charity['country'] == _selectedCountry))
      .toList();

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A67FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4A67FF),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4A67FF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;

    Widget mainContent = Container(
      width: screenSize.width,
      height: screenSize.height,
      color: const Color(0xFF4A67FF),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: const Text(
                'Select Charity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Search and filters section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search charities',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black.withOpacity(0.3),
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category filters
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip(
                          'All Categories',
                          _selectedCategory == null,
                          () => setState(() => _selectedCategory = null),
                        ),
                        const SizedBox(width: 8),
                        ...categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildFilterChip(
                              category,
                              _selectedCategory == category,
                              () => setState(() => _selectedCategory = category),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Country filters
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip(
                          'All Countries',
                          _selectedCountry == null,
                          () => setState(() => _selectedCountry = null),
                        ),
                        const SizedBox(width: 8),
                        ...countries.map((country) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildFilterChip(
                              country,
                              _selectedCountry == country,
                              () => setState(() => _selectedCountry = country),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Charity list section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCharities.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final charity = filteredCharities[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmCharityScreen(
                              charityName: charity['name'] as String,
                              charityColor: charity['color'] as Color,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
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
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: charity['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    charity['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${charity['category']} • ${charity['country']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF4A67FF),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
            width: 393,
            height: 852,
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