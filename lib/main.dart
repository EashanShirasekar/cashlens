import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/transactions_screen.dart';
import 'ui/screens/insights_screen.dart';
import 'ui/screens/goals_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/onboarding_screen.dart';


void main() {
  runApp(CashLensApp());
}

class CashLensApp extends StatefulWidget {
  @override
  State<CashLensApp> createState() => _CashLensAppState();
}

class _CashLensAppState extends State<CashLensApp> {
  bool _showOnboarding = true; // later you can load this from storage

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _showOnboarding
          ? OnboardingScreen(
              onFinished: () {
                setState(() {
                  _showOnboarding = false;
                });
              },
            )
          : HomeSwitcher(),
    );
  }
}


// NEW: Root tab switcher that handles bottom navigation and screen changes
class HomeSwitcher extends StatefulWidget {
  @override
  State<HomeSwitcher> createState() => _HomeSwitcherState();
}

class _HomeSwitcherState extends State<HomeSwitcher> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Place all your main page widgets in this list in order
    final screens = [
      DashboardScreen(),
      TransactionsScreen(),
      InsightsScreen(),
      GoalsScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],

      // It's best to keep just one BottomNav here and control screen state centrally!
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Color(0xFF181a20),
        selectedItemColor: Color(0xFF00F5D4),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF00F5D4),
        child: Icon(Icons.add, color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
