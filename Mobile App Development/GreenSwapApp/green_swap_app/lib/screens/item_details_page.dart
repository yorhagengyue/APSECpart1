import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({super.key});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int _selectedImageIndex = 0;
  final PageController _pageController = PageController();

  final List<String> _productImages = [
    'white_jacket.jpg',
    'blue_jacket.jpg',
    'black_jacket.jpg',
  ];

  final List<Map<String, dynamic>> _relatedItems = [
    {
      'title': "Men's Sports Suit for Running and Gym...",
      'price': '\$25',
      'image': 'orange_jacket.jpg',
      'color': Colors.orange,
    },
    {
      'title': "Men's Sports Suit for Running and Gym...",
      'price': '\$25',
      'image': 'purple_jacket.jpg',
      'color': Colors.purple,
    },
    {
      'title': "Men's Sports Suit for Running and Gym...",
      'price': '\$25',
      'image': 'green_jacket.jpg',
      'color': Colors.green,
    },
    {
      'title': "Men's Sports Suit for Running and Gym...",
      'price': '\$25',
      'image': 'black_jacket2.jpg',
      'color': Colors.black,
    },
    {
      'title': "Men's Sports Suit for Running and Gym...",
      'price': '\$25',
      'image': 'black_hoodie.jpg',
      'color': Colors.black87,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageCarousel(),
                    _buildPriceSection(),
                    _buildProductInfo(),
                    _buildCommentsSection(),
                    _buildRelatedRecommendations(),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
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
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
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
            child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 20),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        // Main image
        Container(
          height: 300,
          color: Colors.grey.shade100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedImageIndex = index;
              });
            },
            itemCount: _productImages.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey.shade100,
                child: Center(
                  child: Icon(
                    Icons.checkroom,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                ),
              );
            },
          ),
        ),
        // Thumbnail images
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_productImages.length, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: index == 0 
                        ? Colors.white 
                        : index == 1 
                            ? Colors.blue.shade100 
                            : Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedImageIndex == index
                          ? const Color(0xFF4CAF50)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.checkroom,
                      size: 30,
                      color: index == 0 
                          ? Colors.grey 
                          : index == 1 
                              ? Colors.blue 
                              : Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 400.ms);
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '\$45',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Or Swap',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Hot Offer',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Swap/Buy',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Propose Swap with 50 credit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 300.ms, delay: 100.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Men's athletic tracksuit for hiking",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '5 swap requests • 120 favorites',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 300.ms, delay: 200.ms)
      .slideX(begin: -0.05, end: 0);
  }

  Widget _buildCommentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Comment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(50+)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tag buttons
          Wrap(
            spacing: 8,
            children: [
              _buildTagButton('Fast Response', isSelected: true),
              _buildTagButton('Good Condition'),
              _buildTagButton('Smooth Swap'),
            ],
          ),
          const SizedBox(height: 20),
          // Comments
          _buildComment(
            name: 'JohnBen',
            comment: 'The swap went flawlessly—the jacket matched the description perfectly and was carefully packaged. The seller responded within minutes and arranged our meetup efficiently. Highly recommended!',
            date: '',
          ),
          const SizedBox(height: 16),
          _buildComment(
            name: 'Aaron Sim',
            comment: 'Nice seller',
            date: '',
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 300.ms, delay: 300.ms);
  }

  Widget _buildTagButton(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildComment({
    required String name,
    required String comment,
    required String date,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade300,
          child: Text(
            name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedRecommendations() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemCount: _relatedItems.length,
            itemBuilder: (context, index) {
              final item = _relatedItems[index];
              return _buildRelatedItem(item, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedItem(Map<String, dynamic> item, int index) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'].withAlpha(51),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.checkroom,
                    size: 40,
                    color: item['color'],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['price'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms, delay: (400 + index * 50).ms)
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        delay: Duration(milliseconds: 400 + index * 50),
      );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            _buildBottomButton(Icons.chat_bubble_outline, 'chat'),
            const SizedBox(width: 12),
            _buildBottomButton(Icons.favorite_border, 'Favorites'),
            const SizedBox(width: 12),
            _buildBottomButton(Icons.shopping_cart_outlined, 'add to cart'),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Buy/Swap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
} 