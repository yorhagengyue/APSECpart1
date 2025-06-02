import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_item_page.dart';
import 'items_page.dart';
import 'profile_page.dart';
import 'chat_details_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<ChatItem> _chatItems = [
    ChatItem(
      name: "GreenSwap",
      avatar: Icons.eco,
      lastMessage: "Welcome to GreenSwap! Start your green journey today.",
      time: "09:30",
      isOfficial: true,
      unreadCount: 1,
    ),
    ChatItem(
      name: "Customer Service",
      avatar: Icons.headset_mic,
      lastMessage: "Hello, I am happy to assist you!",
      time: "Yesterday",
      isOfficial: true,
      unreadCount: 2,
    ),
    ChatItem(
      name: "John Smith",
      avatar: Icons.person,
      lastMessage: "Hi, is the plant still available?",
      time: "Yesterday",
      unreadCount: 3,
    ),
    ChatItem(
      name: "Mary Johnson",
      avatar: Icons.person,
      lastMessage: "Thank you for the quick delivery!",
      time: "Yesterday",
    ),
    ChatItem(
      name: "Alex Wong",
      avatar: Icons.person,
      lastMessage: "Can I pick it up tomorrow afternoon?",
      time: "06/15",
    ),
    ChatItem(
      name: "Lisa Chen",
      avatar: Icons.person,
      lastMessage: "Would you accept \$25 for it?",
      time: "06/14",
    ),
    ChatItem(
      name: "Market Updates",
      avatar: Icons.shopping_bag,
      lastMessage: "New eco-friendly items now available!",
      time: "06/12",
      isOfficial: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: _chatItems.length,
              itemBuilder: (context, index) {
                final item = _chatItems[index];
                return _buildChatItem(item).animate()
                  .fadeIn(delay: Duration(milliseconds: 100 * index), duration: const Duration(milliseconds: 300))
                  .slideX(begin: 0.1, end: 0, delay: Duration(milliseconds: 100 * index), duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search messages',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatItem item) {
    return InkWell(
      onTap: () {
        // Navigate to chat details page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatDetailsPage(
              contactName: item.name,
              contactAvatar: item.avatar.toString(),
              isOfficial: item.isOfficial,
              isCustomerService: item.name == "Customer Service",
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Avatar with badge for official accounts
            Stack(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: item.isOfficial ? const Color(0xFF4CAF50).withAlpha(20) : Colors.grey.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.avatar,
                    color: item.isOfficial ? const Color(0xFF4CAF50) : Colors.grey,
                    size: 30,
                  ),
                ),
                if (item.isOfficial)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Color(0xFF4CAF50),
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.lastMessage,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            item.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
        currentIndex: 3, // Messages tab selected
        onTap: (i) {
          if (i == 0) { // Home tab
            Navigator.of(context).pop(); // Return to home
          } else if (i == 1) { // Item tab
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ItemsPage(),
              ),
            );
          } else if (i == 2) { // Add item tab
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AddItemPage(),
              ),
            );
          } else if (i == 4) { // Profile tab
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          }
          // i == 3 (Messages) - do nothing, already on this page
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

class ChatItem {
  final String name;
  final IconData avatar;
  final String lastMessage;
  final String time;
  final bool isOfficial;
  final int unreadCount;

  ChatItem({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.isOfficial = false,
    this.unreadCount = 0,
  });
} 