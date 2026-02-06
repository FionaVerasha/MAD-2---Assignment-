import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30), // Reduced further
                // Logo and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 80),
                    const SizedBox(width: 15),
                    const Text(
                      "Whisker Cart",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32), // Dark green
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Reduced from 100
                // Headline
                const Text(
                  "Pet care at your\nfingertips!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Sub-headline
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Your one-stop shop for all your furry friend's needs. Quality products delivered to you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ), // Replaced Spacer with fixed spacing
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RegisterPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "SIGNUP",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E7D32),
                            side: const BorderSide(
                              color: Color(0xFF2E7D32),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Terms and conditions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      children: [
                        const TextSpan(
                          text: "By Creating an account, you agree to our ",
                        ),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            color: const Color(0xFF2E7D32).withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " and agree to "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: const Color(0xFF2E7D32).withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Reduced further
              ],
            ),
          ),
          // Wave at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 120,
              child: CustomPaint(painter: WavePainter()),
            ),
          ),
          // Illustration icons on the wave
          Positioned(
            bottom: 20,
            left: 30,
            child: Icon(
              Icons.pets,
              color: Colors.white.withOpacity(0.4),
              size: 40,
            ),
          ),
          Positioned(
            bottom: 40,
            right: 50,
            child: Icon(
              Icons.favorite,
              color: Colors.white.withOpacity(0.4),
              size: 50,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 120,
            child: Icon(
              Icons.home,
              color: Colors.white.withOpacity(0.3),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color =
          const Color(0xFF2E7D32) // Main green wave
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add a second, lighter wave
    var paint2 = Paint()
      ..color = const Color(0xFF43A047).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    var path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.9,
      size.width,
      size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
