import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'message_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'add_item_page.dart';
import 'item_details_page.dart';
import 'items_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  late AnimationController _mascotController;

  final List<_OrderShortcut> _orderShortcuts = const [
    _OrderShortcut('Pending', Icons.history_rounded),
    _OrderShortcut('Payment', Icons.account_balance_wallet_outlined),
    _OrderShortcut('Paid', Icons.check_circle_outline_rounded),
    _OrderShortcut('Review', Icons.rate_review_outlined),
    _OrderShortcut('Refund', Icons.replay_rounded),
  ];

  final List<_Category> _categories = const [
    _Category('Books', Icons.menu_book_rounded),
    _Category('Electronic', Icons.devices_rounded),
    _Category('Furniture', Icons.weekend_rounded),
    _Category('Clothes', Icons.checkroom_rounded),
    _Category('Stationary', Icons.edit_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildWelcomeBubble(),
            const SizedBox(height: 20),
            _buildCategoryRow(),
            const SizedBox(height: 28),
            _buildOrdersSection(),
            const SizedBox(height: 28),
            _buildTopTrend(),
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.black87, size: 20),
        const SizedBox(width: 4),
        const Text(
          'Tampines',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 400.ms)
      .slide(begin: const Offset(-0.1, 0), end: Offset.zero);
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          );
        },
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: 100.ms)
      .slide(begin: const Offset(0, 0.1), end: Offset.zero);
  }

  Widget _buildWelcomeBubble() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withAlpha(51),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Welcome to GreenSwap',
            style: TextStyle(
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const Spacer(),
        _buildMascot(),
      ],
    ).animate()
      .fadeIn(duration: 400.ms, delay: 200.ms)
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildMascot() {
    return AnimatedBuilder(
      animation: _mascotController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -5 * _mascotController.value),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFC8E6C9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withAlpha(77),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Body
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                ),
                // Eyes
                Positioned(
                  top: 12,
                  left: 14,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 14,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Smile
                Positioned(
                  bottom: 15,
                  child: Container(
                    width: 20,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                // Leaf on top
                Positioned(
                  top: 4,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: const Icon(
                      Icons.eco,
                      color: Color(0xFF2E7D32),
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  size: 28,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ).animate()
            .fadeIn(duration: 400.ms, delay: (300 + index * 50).ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              delay: (300 + index * 50).ms,
            );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _orderShortcuts.asMap().entries.map((entry) {
              final index = entry.key;
              final shortcut = entry.value;
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Icon(
                      shortcut.icon,
                      size: 24,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shortcut.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ).animate()
                .fadeIn(duration: 400.ms, delay: (400 + index * 50).ms)
                .slide(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                  delay: (400 + index * 50).ms,
                );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.trending_up, color: Colors.black87, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Top Trend',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '768',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 1000.ms,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 280,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTrendCard(
                title: 'For You',
                image: 'green_chair.jpg',
                isGreenChair: true,
              ),
              const SizedBox(width: 16),
              _buildTrendCard(
                title: "This week's new",
                image: 'new_items.jpg',
              ),
              const SizedBox(width: 16),
              _buildTrendCard(
                title: 'Top Rated',
                image: 'top_rated.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendCard({
    required String title,
    required String image,
    bool isGreenChair = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ItemDetailsPage(),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 140,
                width: double.infinity,
                color: isGreenChair ? Colors.grey.shade200 : Colors.grey.shade300,
                child: isGreenChair
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.chair,
                            size: 80,
                            color: const Color(0xFF4CAF50),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          if (title == "This week's new")
                            // Simulating a product image with icons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fiber_new,
                                  size: 50,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 8),
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 30,
                                  color: Colors.grey.shade500,
                                ),
                              ],
                            )
                          else if (title == 'Top Rated')
                            // Simulating top rated items
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 30,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.trending_up,
                                  size: 40,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                        ],
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ItemDetailsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Explore',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: 500.ms)
      .slide(begin: const Offset(0.2, 0), end: Offset.zero);
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
        currentIndex: _currentIndex,
        onTap: (i) {
          // 只有当点击的不是当前页面时才导航
          if (i != _currentIndex) {
            if (i == 1) { // Item tab
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ItemsPage(),
                ),
              );
            } else if (i == 2) { // Add item tab
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddItemPage(),
                ),
              );
            } else if (i == 3) { // Messages tab
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MessagePage(),
                ),
              );
            } else if (i == 4) { // Profile tab
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            }
            // 不在这里设置_currentIndex，因为我们要保持Home为选中状态
          }
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
}

class _Category {
  final String label;
  final IconData icon;
  const _Category(this.label, this.icon);
}

class _OrderShortcut {
  final String label;
  final IconData icon;
  const _OrderShortcut(this.label, this.icon);
} 