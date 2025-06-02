import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemAddedSuccessPage extends StatelessWidget {
  const ItemAddedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildSuccessIcon(),
              const SizedBox(height: 30),
              _buildSuccessText(),
              const SizedBox(height: 40),
              _buildItemCard(),
              const Spacer(),
              _buildShareButton(context),
              const SizedBox(height: 30),
              _buildPageIndicator(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF26A69A),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 60,
      ),
    ).animate()
      .scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
        duration: 500.ms,
        curve: Curves.elasticOut,
      );
  }

  Widget _buildSuccessText() {
    return Column(
      children: [
        const Text(
          'Item added successfully',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ).animate()
          .fadeIn(delay: 300.ms)
          .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 12),
        Text(
          'Your river-saving campaign is now live and ready\nto make an impact.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ).animate()
          .fadeIn(delay: 400.ms)
          .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildItemCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Item Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for makeup product
                  Icon(
                    Icons.water_drop,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Makeup Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Item Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow('Item Name', 'Make up'),
                const SizedBox(height: 16),
                _buildDetailRow('Date', 'May 5, 2025'),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Donation Status',
                  'Open for Swap',
                  hasCheck: true,
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Target price', '\$50'),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildDetailRow(String label, String value, {bool hasCheck = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Row(
          children: [
            if (hasCheck)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(2),
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Navigate back to home, removing all previous routes
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Share Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: 600.ms)
      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildPageIndicator() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
} 