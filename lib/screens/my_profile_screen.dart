import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Remove default AppBar in favor of a custom header row
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ------------------------------------------------
              // 1) HEADER (Hello, Lucas & Notification Icon)
              // ------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Hello, Lucas 👋"
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello, Lucas 👋",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "How do you feel today?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    // Notification Icon
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to notifications
                      },
                      icon: const Icon(Icons.notifications_outlined),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // 2) PROFILE CARD (LUCAS TAN CHONG WEI)
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
                    // User Avatar
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/vhack_profile.jpg'),
                    ),
                    const SizedBox(width: 16),

                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          const Text(
                            'LUCAS TAN CHONG WEI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Status
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
                              Icon(Icons.male, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Male',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '60174881122',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Row 2: ID + State
                          Row(
                            children: [
                              Icon(Icons.card_membership, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '990411070145',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Pulau Pinang',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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
              // 3) MY SETTINGS (Redesigned)
              // ------------------------------------------------
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'My Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              // Settings in a redesigned card
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
                      title: 'My Personal Details',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.sync,
                      title: 'Guidance Sync',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.support_agent,
                      title: 'CareEase Helpdesk',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: 'Language',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.lock_outline,
                      title: 'Privacy & Security',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.exit_to_app,
                      title: 'Log Out',
                      onTap: () {},
                      showDivider: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
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
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(height: 1, indent: 72, thickness: 0.5),
      ],
    );
  }
}
