import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

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

    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF1B5E20)
        : Colors.grey[200];
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final appBarColor = widget.isDarkMode
        ? const Color(0xFF1B5E20)
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(height: 20),
            Text(
              user?.name ?? "User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user?.email ?? "No email",
              style: TextStyle(fontSize: 16, color: subTextColor),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit profile coming soon!")),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isDarkMode
                    ? Colors.blueGrey[700]
                    : const Color.fromARGB(255, 160, 164, 179),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => auth.logout(),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
