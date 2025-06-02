import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatDetailsPage extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final bool isOfficial;
  final bool isCustomerService;

  const ChatDetailsPage({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    this.isOfficial = false,
    this.isCustomerService = false,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ChatMessage> _messages = [];
  List<String> _faqQuestions = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    if (widget.isCustomerService) {
      _messages = [
        ChatMessage(
          text: "Hello, I am happy to assist you!",
          isFromUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ];
      
      _faqQuestions = [
        "Are the products available?",
        "Member Inquiry",
        "When will my order be shipped?",
        "Does item support a return policy?",
        "More questions",
        "Where can I get coupons?",
        "Is shipping free for my order?",
        "Is there shipping insurance?",
        "I want to apply for a refund for out-of-stock",
      ];
    } else if (widget.contactName == "GreenSwap") {
      _messages = [
        ChatMessage(
          text: "Welcome to GreenSwap! Start your green journey today.",
          isFromUser: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
    } else {
      _messages = [
        ChatMessage(
          text: "Hello, nice to meet you!",
          isFromUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        ChatMessage(
          text: "Hello",
          isFromUser: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (widget.isCustomerService) _buildFAQSection(),
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: widget.isOfficial 
                ? const Color(0xFF4CAF50).withAlpha(20) 
                : Colors.grey.withAlpha(20),
            child: Icon(
              _getAvatarIcon(),
              color: widget.isOfficial ? const Color(0xFF4CAF50) : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.isCustomerService)
                  const Text(
                    "Customer Service",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (widget.isCustomerService)
          IconButton(
            icon: const Icon(Icons.headset_mic, color: Colors.black),
            onPressed: () {},
          ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  IconData _getAvatarIcon() {
    if (widget.isCustomerService) return Icons.headset_mic;
    if (widget.contactName == "GreenSwap") return Icons.eco;
    if (widget.contactName == "Market Updates") return Icons.shopping_bag;
    return Icons.person;
  }

  Widget _buildFAQSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: _faqQuestions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return InkWell(
                onTap: () => _sendFAQMessage(question),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate()
                .fadeIn(delay: Duration(milliseconds: 100 * index))
                .slideX(begin: 0.1, end: 0);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message, index);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isFromUser = message.isFromUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: widget.isOfficial 
                  ? const Color(0xFF4CAF50).withAlpha(20) 
                  : Colors.grey.withAlpha(20),
              child: Icon(
                _getAvatarIcon(),
                color: widget.isOfficial ? const Color(0xFF4CAF50) : Colors.grey,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFromUser 
                    ? const Color(0xFF4CAF50) 
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isFromUser ? 16 : 4),
                  bottomRight: Radius.circular(isFromUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isFromUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.withAlpha(20),
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 100 * index))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: widget.isCustomerService 
                    ? "Say something..." 
                    : "Type a message...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 10,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text.trim(),
        isFromUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    if (widget.isCustomerService) {
      _simulateCustomerServiceReply(text);
    } else {
      _simulateReply(text);
    }
  }

  void _sendFAQMessage(String question) {
    setState(() {
      _messages.add(ChatMessage(
        text: question,
        isFromUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();
    _simulateCustomerServiceReply(question);
  }

  void _simulateReply(String userMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _getReplyText(userMessage),
            isFromUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _simulateCustomerServiceReply(String userMessage) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _getCustomerServiceReply(userMessage),
            isFromUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _getReplyText(String userMessage) {
    if (userMessage.toLowerCase().contains('hello')) {
      return "Nice to meet you too! How can I help you today?";
    } else if (userMessage.toLowerCase().contains('plant')) {
      return "I love plants! Are you looking to swap or buy some green friends?";
    } else if (userMessage.contains('swap')) {
      return "Great! What plants are you interested in swapping?";
    }
    return "Thanks for your message! Let me know if you have any questions.";
  }

  String _getCustomerServiceReply(String userMessage) {
    if (userMessage.contains("Are the products available?")) {
      return "Yes, most of our products are currently available. You can check the availability status on each product page.";
    } else if (userMessage.contains("Member Inquiry")) {
      return "For member-related questions, please provide your member ID and I'll assist you with your inquiry.";
    } else if (userMessage.contains("order be shipped")) {
      return "Orders are typically shipped within 1-2 business days. You'll receive a tracking number once your order is dispatched.";
    } else if (userMessage.contains("return policy")) {
      return "Yes, we offer a 30-day return policy for unused items in original packaging. Would you like to initiate a return?";
    } else if (userMessage.contains("coupons")) {
      return "You can find available coupons in the 'Promotions' section of your profile or check our weekly newsletter.";
    } else if (userMessage.contains("shipping free")) {
      return "Free shipping is available for orders over \$50. Orders under \$50 have a shipping fee of \$5.99.";
    } else if (userMessage.contains("shipping insurance")) {
      return "Yes, we offer shipping insurance for valuable items. It's automatically included for orders over \$100.";
    } else if (userMessage.contains("refund")) {
      return "I can help you with the refund process. Please provide your order number and reason for the refund.";
    }
    return "Thank you for contacting us. Our team will review your message and get back to you shortly.";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });
} 