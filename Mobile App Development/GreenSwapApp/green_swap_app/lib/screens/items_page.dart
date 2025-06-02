import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'item_details_page.dart';
import 'add_item_page.dart';
import 'message_page.dart';
import 'profile_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final List<Map<String, dynamic>> _items = [
    {
      'title': 'Vintage Leather Jacket',
      'price': '\$45',
      'location': 'Tampines',
      'category': 'Clothes',
      'image': 'jacket1.jpg',
      'daysAgo': '2 days ago',
      'isSwap': true,
    },
    {
      'title': 'Wooden Coffee Table',
      'price': '\$120',
      'location': 'Bedok',
      'category': 'Furniture',
      'image': 'table.jpg',
      'daysAgo': '5 days ago',
      'isSwap': false,
    },
    {
      'title': 'Professional Camera',
      'price': '\$280',
      'location': 'Jurong',
      'category': 'Electronic',
      'image': 'camera.jpg',
      'daysAgo': '1 day ago',
      'isSwap': true,
    },
    {
      'title': 'Study Books Set',
      'price': '\$35',
      'location': 'Enous',
      'category': 'Books',
      'image': 'books.jpg',
      'daysAgo': '3 days ago',
      'isSwap': false,
    },
    {
      'title': 'Running Shoes',
      'price': '\$60',
      'location': 'Pasir Ris',
      'category': 'Clothes',
      'image': 'shoes.jpg',
      'daysAgo': '4 days ago',
      'isSwap': true,
    },
    {
      'title': 'Desk Lamp',
      'price': '\$25',
      'location': 'Paya Lebar',
      'category': 'Furniture',
      'image': 'lamp.jpg',
      'daysAgo': '6 days ago',
      'isSwap': false,
    },
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Clothes', 'Electronic', 'Furniture', 'Books', 'Stationary'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Items',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _buildItemsGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ).animate()
              .fadeIn(duration: 300.ms, delay: (index * 50).ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                delay: Duration(milliseconds: index * 50),
              ),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid() {
    final filteredItems = _selectedCategory == 'All'
        ? _items
        : _items.where((item) => item['category'] == _selectedCategory).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildItemCard(item, index);
      },
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ItemDetailsPage(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Days ago badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['daysAgo'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                // Swap/Sell badge
                if (item['isSwap'])
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'swap',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Item details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['location']} · ${item['category']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      item['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: (200 + index * 100).ms)
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        delay: Duration(milliseconds: 200 + index * 100),
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
        currentIndex: 1, // Item tab selected
        onTap: (i) {
          if (i == 0) { // Home tab
            Navigator.of(context).pop(); // Return to home
          } else if (i == 2) { // Add item tab
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AddItemPage(),
              ),
            );
          } else if (i == 3) { // Messages tab
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MessagePage(),
              ),
            );
          } else if (i == 4) { // Profile tab
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          }
          // i == 1 (Items) - do nothing, already on this page
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