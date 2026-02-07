import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'package:provider/provider.dart';
import 'providers/checkout_provider.dart';

class CheckoutPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const CheckoutPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final address = checkoutProvider.address;

    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : Colors.grey[200];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final appBarColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFF2E7D32);
    final accentColor = isDarkMode
        ? Colors.greenAccent[700]!
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Confirm Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            const SizedBox(height: 24),
            Text(
              "Shipping to",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address.firstName} ${address.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.address,
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  Text(
                    "${address.city}, ${address.state} ${address.postalCode}",
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  Text(
                    address.country,
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Phone: ${address.phoneNumber}",
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            ...cartManager.items.map((item) {
              return Card(
                color: cardColor,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFF2E7D32),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  subtitle: Text(
                    "Qty: ${item.quantity} | Size: ${item.size}",
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  trailing: Text(
                    "Rs. ${(item.price * item.quantity).toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "Rs. ${cartManager.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Order Placed Successfully!"),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  cartManager.clearCart();
                  // Back to home/shop
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              },
              child: const Text(
                "Place Order",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep("Review", true, true),
        _buildLine(true),
        _buildStep("Address", true, true),
        _buildLine(true),
        _buildStep("Confirm", true, false),
      ],
    );
  }

  Widget _buildStep(String label, bool isActive, bool isComplete) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isComplete
                ? const Color(0xFF2E7D32)
                : (isActive ? const Color(0xFF2E7D32) : Colors.grey[300]),
            shape: BoxShape.circle,
          ),
          child: isComplete
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF2E7D32) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300],
        margin: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}
