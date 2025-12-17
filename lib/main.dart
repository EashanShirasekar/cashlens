import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/transactions_screen.dart';
import 'ui/screens/insights_screen.dart';
import 'ui/screens/goals_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'services/sms_service.dart';
import 'state/transactions_provider.dart';


void main() {
  runApp(ProviderScope(child: CashLensApp()));
}

class CashLensApp extends ConsumerStatefulWidget {
  const CashLensApp({super.key});
  @override
  ConsumerState<CashLensApp> createState() => _CashLensAppState();
}

class _CashLensAppState extends ConsumerState<CashLensApp> {
  bool _showOnboarding = true; // later you can load this from storage
  final SmsService _smsService = SmsService();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _smsService.start(onParsed: (parsed) {
        ref.read(transactionsProvider.notifier).addParsed(parsed);
      });
    }
  }

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
  const HomeSwitcher({super.key});

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
