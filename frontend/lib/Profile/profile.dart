import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../MainPage/mainpage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Store current language; default is English
  String _currentLanguage = "English";

  // Update the language
  void _updateLanguage(String language) {
    setState(() {
      _currentLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                // ------------------------------------------------
                // PROFILE CARD
                // ------------------------------------------------
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/vhack_profile.jpg'),
                      ),
                      const SizedBox(width: 16),
                      // User Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LUCAS TAN CHONG WEI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Low Risk • No Symptom',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Row 1: Gender + Phone
                            Row(
                              children: [
                                Icon(Icons.male,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                const Text(
                                  'Male',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.phone,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                const Text(
                                  '60174881122',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Row 2: ID + State
                            Row(
                              children: [
                                Icon(Icons.card_membership,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                const Text(
                                  '990411070145',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.location_on_outlined,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                const Text(
                                  'Pulau Pinang',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // ------------------------------------------------
                // MY SETTINGS HEADER
                // ------------------------------------------------
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    "My Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                // ------------------------------------------------
                // SETTINGS CARD
                // ------------------------------------------------
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.person_outline,
                        title: "My Personal Details",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.sync,
                        title: "Guidance Sync",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.support_agent,
                        title: "CareEase Helpdesk",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.language,
                        title: "Language",
                        subtitle: _currentLanguage,
                        onTap: () => _showLanguagePicker(context),
                      ),
                      _buildSettingsItem(
                        icon: Icons.lock_outline,
                        title: "Privacy & Security",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.exit_to_app,
                        title: "Log Out",
                        onTap: () {
                          // Navigate to MainPage when logging out
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                          );
                        },
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                // ------------------------------------------------
                // SECURITY ALERT WITH BLUE BACKGROUND
                // ------------------------------------------------
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your data is securely encrypted and protected according to industry standards.",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each settings row
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 72,
            thickness: 0.5,
          ),
      ],
    );
  }

  // Language picker using CupertinoActionSheet
  void _showLanguagePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text("Select Language"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text("English"),
            onPressed: () {
              _updateLanguage("English");
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Malay"),
            onPressed: () {
              _updateLanguage("Malay");
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Chinese"),
            onPressed: () {
              _updateLanguage("Chinese");
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Tamil"),
            onPressed: () {
              _updateLanguage("Tamil");
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
