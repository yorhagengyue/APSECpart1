import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _searchHistory = [
    'chair',
    'Pens',
    'stationary',
    'makeup',
    'plate',
  ];

  final List<String> _locations = [
    'Tampines',
    'Bedok north',
    'Enous',
    'Jurong',
    'Pasir ris',
    'Paya Lebar',
  ];

  final List<TrendingItem> _trendingItems = [
    TrendingItem(
      rank: 1,
      title: 'Vintage Pine Coffee Table',
      description: 'Solid wood, light distress patina\n—perfect for a cozy living room.',
    ),
    TrendingItem(
      rank: 2,
      title: 'Patagonia Synchilla Fleece Jacket (M, Navy)',
      description: 'Lightly worn, warm and wind-resistant\nfor autumn outings.',
    ),
    TrendingItem(
      rank: 3,
      title: 'LEGO Star Wars: Millennium Falcon Set',
      description: '95% complete with original instructions\n—collector\'s item for fans.',
    ),
    TrendingItem(
      rank: 4,
      title: 'Yamaha Acoustic Guitar (FG800)',
      description: 'Great tone, includes soft case\n—fantastic for beginners.',
    ),
    TrendingItem(
      rank: 5,
      title: 'Monstera Deliciosa (4" pot)',
      description: 'Healthy cutting ready to repot\n—adds instant green to any room.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search the item you want',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Handle search
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchHistory(),
          const SizedBox(height: 24),
          _buildSearchByLocation(),
          const SizedBox(height: 24),
          _buildTrendingItems(),
          const SizedBox(height: 80), // Space for bottom nav
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _searchHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ).animate()
              .fadeIn(delay: Duration(milliseconds: 100 * index))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                delay: Duration(milliseconds: 100 * index),
              );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchByLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search by Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _locations.asMap().entries.map((entry) {
            final index = entry.key;
            final location = entry.value;
            return InkWell(
              onTap: () {
                // Handle location tap
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Text(
                  location,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ).animate()
              .fadeIn(delay: Duration(milliseconds: 200 + 50 * index))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                delay: Duration(milliseconds: 200 + 50 * index),
              );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTrendingItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Trending Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '🔥',
              style: const TextStyle(fontSize: 20),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
              duration: 1000.ms,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(_trendingItems.length, (index) {
          return _buildTrendingItem(_trendingItems[index], index);
        }),
      ],
    );
  }

  Widget _buildTrendingItem(TrendingItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Handle item tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${item.rank}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
      .slideX(
        begin: 0.1,
        end: 0,
        delay: Duration(milliseconds: 300 + 100 * index),
      );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0, // Home tab selected since we came from home
        onTap: (i) {
          Navigator.of(context).pop(); // Navigate back to home
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Item',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'add item',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Mine',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class TrendingItem {
  final int rank;
  final String title;
  final String description;

  TrendingItem({
    required this.rank,
    required this.title,
    required this.description,
  });
} 