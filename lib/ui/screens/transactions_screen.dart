import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/top_bar.dart';
import '../widgets/glass_card.dart';
import '../../state/transactions_provider.dart';


class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  int selectedIndex = 1; // Change this to match which nav item is transactions

  String searchQuery = '';
  String selectedCategory = 'All';

  final categories = ['All', 'Income', 'Food & Drink', 'Transport', 'Shopping', 'Housing'];

  List<Map<String, dynamic>> get allTransactions {
    final list = ref.watch(transactionsProvider);
    return list.map((t) {
      final color = _colorForCategory(t.category);
      final icon = _iconForCategory(t.category);
      return {
        'id': t.id,
        'merchant': t.merchant,
        'category': t.category,
        'amount': t.amount,
        'date': t.date,
        'time': '',
        'icon': icon,
        'color': color,
      };
    }).toList();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    return allTransactions.where((transaction) {
      final matchesSearch = transaction['merchant']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All'
          ? true
          : transaction['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141821),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(title: 'Transactions'),
              SizedBox(height: 10),
              // Search and Filter
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                            hintText: 'Search transactions...',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: (val) => setState(() => searchQuery = val),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                      ),
                      child: Icon(Icons.filter_alt, color: Color(0xFF00F5D4)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Category Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: categories.map((category) {
                    final isActive = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isActive ? Color(0xFF00F5D4) : Colors.grey,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isActive,
                        pressElevation: 0,
                        elevation: 0,
                        selectedColor: Color(0xFF00F5D4).withValues(alpha: 0.19),
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.transparent)),
                        onSelected: (_) => setState(() => selectedCategory = category),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              // Transactions List
              Column(
                children: filteredTransactions.map((transaction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: transaction['color'].withValues(alpha: 0.19),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(transaction['icon'], color: transaction['color'], size: 26),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(transaction['merchant'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: transaction['color'].withValues(alpha: 0.19),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          transaction['category'],
                                          style: TextStyle(color: transaction['color'], fontSize: 10, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text('${transaction['date']} • ${transaction['time']}', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${transaction['amount'] > 0 ? '+' : ''}₹${transaction['amount'].abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: transaction['amount'] > 0 ? Color(0xFF00F5D4) : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
      // Floating Action Button
      
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Food & Drink':
        return Icons.local_cafe;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Housing':
        return Icons.home;
      case 'Salary':
      case 'Income':
        return Icons.trending_up;
      default:
        return Icons.payment;
    }
  }

  Color _colorForCategory(String category) {
    switch (category) {
      case 'Food & Drink':
        return Color(0xFFF59E0B);
      case 'Transport':
        return Color(0xFF00A3FF);
      case 'Shopping':
        return Color(0xFF8B5CF6);
      case 'Housing':
        return Color(0xFFFF6B6B);
      case 'Salary':
      case 'Income':
        return Color(0xFF00FFC6);
      default:
        return Color(0xFF00F5D4);
    }
  }
}

// -- GlassCard widget (used for all cards, already in your codebase) --
// -- TopBar widget (used for titlebar, already in your codebase) --
// -- BottomNav widget (used for nav at bottom, already in your codebase) --
