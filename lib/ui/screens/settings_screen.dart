import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141821),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(title: "Settings"),
              SizedBox(height: 10),

              // Profile Card
              GlassCard(
                
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF00F5D4), Color(0xFF0EA5FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(Icons.person, color: Colors.black, size: 32),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("John Doe", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 1),
                            Text("john.doe@example.com", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          backgroundColor: Color(0xFF00F5D4).withOpacity(0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {},
                        child: Text("Edit", style: TextStyle(color: Color(0xFF00F5D4), fontSize: 13)),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 18),

              // Account Section
              Text("Account", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              SizedBox(height: 7),
              GlassCard(
                child: Column(
                  children: [
                    _settingRow(icon: Icons.person, label: "Profile Settings", trailing: Icon(Icons.chevron_right, color: Colors.grey[500]), onTap: () {}),
                    _divider(),
                    _settingRow(icon: Icons.lock, label: "Privacy & Security", trailing: Icon(Icons.chevron_right, color: Colors.grey[500]), onTap: () {}),
                    _divider(),
                    _settingRow(
                        icon: Icons.credit_card,
                        label: "Linked Bank Accounts",
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _badge("3", color: Color(0xFF00F5D4)),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, color: Colors.grey[500])
                          ],
                        ),
                        onTap: () {}),
                  ],
                ),
              ),

              SizedBox(height: 24),
              Text("Preferences", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              SizedBox(height: 7),
              GlassCard(
                child: Column(
                  children: [
                    _switchRow(
                        icon: Icons.notifications_active,
                        label: "Notifications",
                        value: notifications,
                        onChanged: (v) => setState(() => notifications = v)),
                    _divider(),
                    _switchRow(
                        icon: Icons.nightlight_round,
                        label: "Dark Mode",
                        value: darkMode,
                        onChanged: (v) => setState(() => darkMode = v)),
                    _divider(),
                    _settingRow(
                        icon: Icons.sms, label: "Grant SMS Access", trailing: null, onTap: () {}),
                  ],
                ),
              ),

              SizedBox(height: 24),
              Text("Data & Privacy", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              SizedBox(height: 7),
              GlassCard(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      title: Text("Export Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Text("Download all your financial data", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      onTap: () {},
                    ),
                    _divider(),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      title: Text("Delete Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Text("Permanently delete your account and data", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18),
              // Logout
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFFFF6B6B).withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.02),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Color(0xFFFF6B6B), size: 20),
                          SizedBox(width: 8),
                          Text("Log Out", style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // App Info
              SizedBox(height: 22),
              Center(
                child: Column(
                  children: [
                    Text("CashLens v1.0.0",
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 12, letterSpacing: .5)),
                    SizedBox(height: 3),
                    Text(
                      "Made with ❤️ for better financial health",
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white.withOpacity(0.05),
      margin: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _settingRow({
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Color(0xFF00F5D4), size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
                child: Text(label,
                    style: TextStyle(color: Colors.white, fontSize: 15))),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _switchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Color(0xFF00F5D4), size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
              child: Text(label,
                  style: TextStyle(color: Colors.white, fontSize: 15))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Color(0xFF00F5D4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _badge(String value, {required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
