import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const BottomNav({super.key, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.receipt_long, 'label': 'Transactions'},
      {'icon': Icons.pie_chart_outline, 'label': 'Insights'},
      {'icon': Icons.flag, 'label': 'Goals'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onSelect,
      backgroundColor: Color(0xFF00F5D4).withValues(alpha: 0.10),
      selectedItemColor: Color(0xFF00F5D4),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: items
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item['icon'] as IconData),
                label: item['label'] as String,
              ))
          .toList(),
    );
  }
}
