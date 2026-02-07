import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_page.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';
import 'providers/product_provider.dart';
import 'models/product.dart';
import 'productdetail_page.dart';
import 'widgets/product_image.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    // Load products on start
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor = isDarkMode
        ? Colors.tealAccent[700]!
        : const Color(0xFF2E7D32);
    final appBarColor = isDarkMode
        ? const Color(0xFF1B5E20)
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 3,
        title: const Text(
          "Whisker Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShopPage(
                    isDarkMode: isDarkMode,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => pages.CartPage(
                        isDarkMode: isDarkMode,
                        onToggleTheme: (value) {
                          setState(() => isDarkMode = value);
                          widget.onToggleTheme(value);
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.totalItems.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
              widget.onToggleTheme(isDarkMode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHero(textColor, accentColor),

            // Best Sellers (From API)
            _buildProductSection(
              "Best Sellers",
              productProvider.products.take(4).toList(),
              productProvider.isLoading,
            ),

            // Categories (Statics)
            _buildCategorySection(),

            // New Arrivals (From API)
            _buildProductSection(
              "New Arrivals",
              productProvider.products.reversed.take(4).toList(),
              productProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Color textColor, Color accentColor) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/main.jpg',
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          color: isDarkMode ? Colors.black.withOpacity(0.6) : null,
          colorBlendMode: isDarkMode ? BlendMode.darken : null,
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Find the Best Pet Products",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Shop for your furry friend with ease",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopPage(
                          isDarkMode: isDarkMode,
                          onToggleTheme: widget.onToggleTheme,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Shop Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductSection(
    String title,
    List<Product> products,
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            )
          else if (products.isEmpty)
            Center(
              child: Text(
                "No products available",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _buildProductCard(products[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(
            product: product,
            isDarkMode: isDarkMode,
            onToggleTheme: widget.onToggleTheme,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ProductImage(
                        url: product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              product: product,
                              isDarkMode: isDarkMode,
                              onToggleTheme: widget.onToggleTheme,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    "Rs. ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      {"name": "Dogs", "image": "assets/images/dogs.png"},
      {"name": "Cats", "image": "assets/images/cats.png"},
      {"name": "Accessories", "image": "assets/images/accessories.png"},
      {"name": "Grooming", "image": "assets/images/grooming.png"},
    ];

    return Container(
      color: isDarkMode
          ? const Color(0xFF2C2C2C)
          : const Color.fromARGB(255, 232, 234, 246),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Featured Categories",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShopPage(
                      isDarkMode: isDarkMode,
                      onToggleTheme: widget.onToggleTheme,
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 15),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          categories[index]["image"]!,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        categories[index]["name"]!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
