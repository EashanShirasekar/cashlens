import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/glass_card.dart';


class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int selectedIndex = 1; // Change this to match which nav item is transactions

  String searchQuery = '';
  String selectedCategory = 'All';

  final categories = ['All', 'Income', 'Food & Drink', 'Transport', 'Shopping', 'Housing'];

  final List<Map<String, dynamic>> allTransactions = [
    {
      'id': 1,
      'merchant': 'Starbucks Coffee',
      'category': 'Food & Drink',
      'amount': -5.50,
      'date': 'Oct 10, 2025',
      'time': '09:30 AM',
      'icon': Icons.local_cafe,
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 2,
      'merchant': 'Uber Ride',
      'category': 'Transport',
      'amount': -12.30,
      'date': 'Oct 10, 2025',
      'time': '08:15 AM',
      'icon': Icons.directions_car,
      'color': Color(0xFF00A3FF),
    },
    {
      'id': 3,
      'merchant': 'Amazon Purchase',
      'category': 'Shopping',
      'amount': -45.99,
      'date': 'Oct 9, 2025',
      'time': '06:45 PM',
      'icon': Icons.shopping_bag,
      'color': Color(0xFF8B5CF6),
    },
    {
      'id': 4,
      'merchant': 'Monthly Salary',
      'category': 'Income',
      'amount': 3500.00,
      'date': 'Oct 1, 2025',
      'time': '12:00 AM',
      'icon': Icons.trending_up,
      'color': Color(0xFF00FFC6),
    },
    {
      'id': 5,
      'merchant': 'Rent Payment',
      'category': 'Housing',
      'amount': -1200.00,
      'date': 'Oct 1, 2025',
      'time': '10:00 AM',
      'icon': Icons.home,
      'color': Color(0xFFFF6B6B),
    },
    {
      'id': 6,
      'merchant': 'Dinner at Olive Garden',
      'category': 'Food & Drink',
      'amount': -68.50,
      'date': 'Oct 8, 2025',
      'time': '07:30 PM',
      'icon': Icons.restaurant,
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 7,
      'merchant': 'Gas Station',
      'category': 'Transport',
      'amount': -45.00,
      'date': 'Oct 7, 2025',
      'time': '05:00 PM',
      'icon': Icons.local_gas_station,
      'color': Color(0xFF00A3FF),
    },
    {
      'id': 8,
      'merchant': 'Grocery Store',
      'category': 'Shopping',
      'amount': -89.23,
      'date': 'Oct 6, 2025',
      'time': '11:30 AM',
      'icon': Icons.shopping_bag,
      'color': Color(0xFF8B5CF6),
    },
  ];

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
                            fillColor: Colors.white.withOpacity(0.05),
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
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.10)),
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
                        selectedColor: Color(0xFF00F5D4).withOpacity(0.19),
                        backgroundColor: Colors.white.withOpacity(0.05),
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
                                color: transaction['color'].withOpacity(0.19),
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
                                          color: transaction['color'].withOpacity(0.19),
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
}

// -- GlassCard widget (used for all cards, already in your codebase) --
// -- TopBar widget (used for titlebar, already in your codebase) --
// -- BottomNav widget (used for nav at bottom, already in your codebase) --
