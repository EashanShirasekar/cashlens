import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/glass_card.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  String timeRange = '7';

  final double totalBalance = 66093.97;
  final double income = 3500;
  final double expense = 1353.78;

  final List<Map<String, dynamic>> chartData = [
    {'date': 'Mon', 'income': 4000.0, 'expense': 2400.0},
    {'date': 'Tue', 'income': 3000.0, 'expense': 1398.0},
    {'date': 'Wed', 'income': 2000.0, 'expense': 3800.0},
    {'date': 'Thu', 'income': 2780.0, 'expense': 3908.0},
    {'date': 'Fri', 'income': 1890.0, 'expense': 4800.0},
    {'date': 'Sat', 'income': 2390.0, 'expense': 3800.0},
    {'date': 'Sun', 'income': 3490.0, 'expense': 4300.0},
  ];

  // Mock Top Recommendation and Bills Example
  final Map<String, dynamic> mockTopRecommendation = {
    'message': "You're spending 15% less on Food & Drink compared to last month.",
  };

  final List<Map<String, dynamic>> mockUpcomingBills = [
    {
      'billName': "Electricity Bill",
      'amount': 1200.00,
    },
  ];

  final List<Map<String, dynamic>> mockRecentTransactions = [
    {
      'id': 1,
      'merchant': "Starbucks Coffee",
      'category': "Food & Drink",
      'amount': 5.50,
      'isCredit': false,
      'date': DateTime.now(),
    },
    {
      'id': 2,
      'merchant': "Uber Ride",
      'category': "Transport",
      'amount': 12.30,
      'isCredit': false,
      'date': DateTime.now(),
    },
    {
      'id': 3,
      'merchant': "Amazon Purchase",
      'category': "Shopping",
      'amount': 45.99,
      'isCredit': false,
      'date': DateTime.now(),
    },
    {
      'id': 4,
      'merchant': "Monthly Salary",
      'category': "Salary",
      'amount': 3500.00,
      'isCredit': true,
      'date': DateTime.now(),
    },
    {
      'id': 5,
      'merchant': "Rent Payment",
      'category': "Housing",
      'amount': 1200.00,
      'isCredit': false,
      'date': DateTime.now(),
    },
  ];

  IconData _getIcon(String category) {
    switch (category) {
      case 'Food & Drink':
        return Icons.local_cafe;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Salary':
        return Icons.trending_up;
      case 'Housing':
        return Icons.home;
      default:
        return Icons.payment;
    }
  }

  Color _getColor(int index) {
    List<Color> colors = [
      Color(0xFFF59E0B),
      Color(0xFF00A3FF),
      Color(0xFF8B5CF6),
      Color(0xFF00F5D4),
      Color(0xFFFF6B6B),
    ];
    return colors[index % colors.length];
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
              TopBar(),
              SizedBox(height: 3),
              GlassCard(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Developer Note: Aggregated data from multiple Firestore collections: accounts (balance sum), transactions (income/expense filtering), recommendations (AI tips), goals (progress tracking).",
                    style: TextStyle(fontSize: 11, color: Colors.tealAccent.shade100.withValues(alpha: 0.7)),
                  ),
                ),
              ),
              GlassCard(
               
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Balance", style: TextStyle(color: Colors.grey, fontSize: 15)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF00F5D4).withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.trending_up, color: Color(0xFF00F5D4), size: 16),
                                SizedBox(width: 4),
                                Text("12.5%", style: TextStyle(color: Color(0xFF00F5D4), fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("₹$totalBalance", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Income", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Row(
                                children: [
                                  Icon(Icons.arrow_downward, color: Color(0xFF00F5D4), size: 16),
                                  SizedBox(width: 3),
                                  Text("₹$income", style: TextStyle(color: Color(0xFF00F5D4))),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 28),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expenses", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Row(
                                children: [
                                  Icon(Icons.arrow_upward, color: Color(0xFF00A3FF), size: 16),
                                  SizedBox(width: 3),
                                  Text("₹$expense", style: TextStyle(color: Color(0xFF00A3FF))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 2.3,
                children: [
                  _QuickActionButton(icon: Icons.add, color: Color(0xFF00F5D4), label: "Add Account"),
                  _QuickActionButton(icon: Icons.account_balance_wallet, color: Color(0xFF00A3FF), label: "Transfer"),
                  _QuickActionButton(icon: Icons.flag, color: Color(0xFF8B5CF6), label: "Auto-save"),
                  _QuickActionButton(icon: Icons.trending_up, color: Color(0xFFF59E0B), label: "Insights"),
                ],
              ),
              SizedBox(height: 8),
              GlassCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Spending Overview", style: TextStyle(color: Colors.white, fontSize: 16)),
                          Row(
                            children: ["7", "30", "90"]
                                .map((days) => TextButton(
                                      onPressed: () {
                                        setState(() {
                                          timeRange = days;
                                        });
                                      },
                                      child: Text(
                                        '${days}d',
                                        style: TextStyle(
                                          color: timeRange == days ? Color(0xFF00F5D4) : Colors.grey,
                                          fontWeight: timeRange == days ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 170,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                axisNameWidget: Text(''),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 35,
                                  interval: 1000,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                                    if (value >= 0 && value < labels.length) {
                                      return Text(labels[value.toInt()], style: TextStyle(color: Colors.grey, fontSize: 10));
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: true, horizontalInterval: 1000),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(chartData.length,
                                    (i) => FlSpot(i.toDouble(), chartData[i]['income'] as double)),
                                isCurved: true,
                                color: Color(0xFF00F5D4),
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: List.generate(chartData.length,
                                    (i) => FlSpot(i.toDouble(), chartData[i]['expense'] as double)),
                                isCurved: true,
                                color: Color(0xFF0EA5FF),
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14),

              // AI Recommendation & Upcoming Bills in vertical layout
              ...[
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF00F5D4).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(Icons.flash_on, color: Color(0xFF00F5D4), size: 22),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Smart Insight", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(height: 3),
                            Text(mockTopRecommendation['message'], style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
              if (mockUpcomingBills.isNotEmpty) ...[
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF6B6B).withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 22),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Upcoming Bills", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(height: 3),
                              Text(
                                "${mockUpcomingBills.length} bill${mockUpcomingBills.length > 1 ? 's' : ''} pending • Next: ${mockUpcomingBills[0]['billName']} (₹${mockUpcomingBills[0]['amount']})",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],

              /// Recent Transactions Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recent Transactions", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Last ${mockRecentTransactions.length}", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: List.generate(mockRecentTransactions.length, (index) {
                      final tx = mockRecentTransactions[index];
                      final txColor = _getColor(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: txColor.withValues(alpha: 0.19),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(_getIcon(tx['category']), color: txColor, size: 22),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(tx['merchant'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: txColor.withValues(alpha: 0.19),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(tx['category'],
                                                style: TextStyle(color: txColor, fontSize: 11)),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${tx['date'].day}/${tx['date'].month}/${tx['date'].year}",
                                            style: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${tx['isCredit'] ? '+' : '-'}₹${tx['amount'].toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: tx['isCredit'] ? Color(0xFF00F5D4) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      
    );
  }
}

// Quick actions
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _QuickActionButton({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GlassCard(
        child: InkWell(
          onTap: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 8),
              Expanded(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 13))),
            ],
          ),
        ),
      ),
    );
  }
}
