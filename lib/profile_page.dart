import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'network_status_page.dart';
import 'battery_status_page.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(user),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildMenuCard([
                    _buildMenuItem(
                      Icons.dashboard_outlined,
                      "Edit profile information",
                    ),
                    _buildMenuItem(
                      Icons.notifications_none,
                      "Notifications",
                      trailing: "ON",
                    ),
                    _buildMenuItem(
                      Icons.translate,
                      "Language",
                      trailing: "English",
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildMenuCard([
                    _buildMenuItem(Icons.security, "Security"),
                    _buildMenuItem(
                      Icons.wb_sunny_outlined,
                      "Theme",
                      trailing: widget.isDarkMode ? "Dark mode" : "Light mode",
                      onTap: () => widget.onToggleTheme(!widget.isDarkMode),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildMenuCard([
                    _buildMenuItem(Icons.help_outline, "Help & Support"),
                    _buildMenuItem(Icons.chat_bubble_outline, "Contact us"),
                    _buildMenuItem(
                      Icons.privacy_tip_outlined,
                      "Privacy policy",
                    ),
                    _buildMenuItem(
                      Icons.wifi,
                      "Network Status",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NetworkStatusPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.battery_full,
                      "Battery Status",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BatteryStatusPage(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildLogoutButton(auth),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF556B2F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.1),
                    width: 8,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFE1F5FE),
                  backgroundImage: AssetImage(
                    'assets/images/logo.png',
                  ), // Using logo as fallback
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? "Laiba Ahmar",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${user?.email ?? 'youremail@domain.com'} | +01 234 567 89",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(AuthProvider auth) {
    return ListTile(
      onTap: () => auth.logout(),
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: const Text(
        "Logout",
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
