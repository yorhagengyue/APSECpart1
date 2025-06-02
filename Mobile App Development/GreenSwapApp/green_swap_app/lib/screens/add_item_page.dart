import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'item_added_success_page.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _targetTimeController = TextEditingController();

  bool _openSwap = true;
  bool _openChat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add item',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageUploadSection(),
              const SizedBox(height: 30),
              _buildItemNameField(),
              const SizedBox(height: 20),
              _buildDateTimeField(),
              const SizedBox(height: 25),
              _buildOpenSwapToggle(),
              const SizedBox(height: 25),
              _buildPriceField(),
              const SizedBox(height: 20),
              _buildTargetTimeField(),
              const SizedBox(height: 25),
              _buildOpenChatToggle(),
              const SizedBox(height: 40),
              _buildAddItemButton(),
              const SizedBox(height: 30),
              _buildPageIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle file browse
                  },
                  icon: const Icon(Icons.upload_file, size: 20),
                  label: const Text('Browse File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'PNG, JPG (max. 800 x 400px)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn(duration: 400.ms)
          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildItemNameField() {
    return _buildTextField(
      label: 'Item name',
      controller: _itemNameController,
      icon: Icons.flash_on,
      hint: 'Insert Item name',
      iconColor: Colors.amber,
    );
  }

  Widget _buildDateTimeField() {
    return _buildTextField(
      label: 'Date time',
      controller: _dateTimeController,
      icon: Icons.calendar_today_outlined,
      hint: 'Time of item you buy',
      iconColor: Colors.grey.shade700,
      onTap: () {
        // Handle date picker
      },
    );
  }

  Widget _buildPriceField() {
    return _buildTextField(
      label: 'Target price collected',
      controller: _priceController,
      icon: Icons.attach_money,
      hint: 'Insert price',
      iconColor: Colors.grey.shade700,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildTargetTimeField() {
    return _buildTextField(
      label: 'Target collection time',
      controller: _targetTimeController,
      icon: Icons.calendar_today_outlined,
      hint: 'Target time',
      iconColor: Colors.grey.shade700,
      onTap: () {
        // Handle date/time picker
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required Color iconColor,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(icon, color: iconColor, size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 300.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildOpenSwapToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Open Swap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _openSwap,
                onChanged: (value) {
                  setState(() {
                    _openSwap = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Other user can use item to swap with you',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 300.ms, delay: 100.ms)
      .slideX(begin: -0.05, end: 0);
  }

  Widget _buildOpenChatToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Open chat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _openChat,
                onChanged: (value) {
                  setState(() {
                    _openChat = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Other users can negotiate with you.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 300.ms, delay: 200.ms)
      .slideX(begin: -0.05, end: 0);
  }

  Widget _buildAddItemButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to success page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ItemAddedSuccessPage(),
            ),
          );
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
          'Add Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: 300.ms)
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

  @override
  void dispose() {
    _itemNameController.dispose();
    _dateTimeController.dispose();
    _priceController.dispose();
    _targetTimeController.dispose();
    super.dispose();
  }
} 