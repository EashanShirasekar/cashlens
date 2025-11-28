import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/glass_card.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsScreen extends StatefulWidget {
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final List<Map<String, dynamic>> categoryData = [
    {'name': 'Food & Drink', 'value': 450.0, 'color': Color(0xFFF59E0B)},
    {'name': 'Transport', 'value': 320.0, 'color': Color(0xFF00A3FF)},
    {'name': 'Shopping', 'value': 680.0, 'color': Color(0xFF8B5CF6)},
    {'name': 'Housing', 'value': 1200.0, 'color': Color(0xFFFF6B6B)},
    {'name': 'Entertainment', 'value': 240.0, 'color': Color(0xFF00FFC6)},
  ];

  final List<Map<String, dynamic>> monthlyData = [
    {'month': 'Jul', 'income': 3200.0, 'expense': 2400.0},
    {'month': 'Aug', 'income': 3500.0, 'expense': 2800.0},
    {'month': 'Sep', 'income': 3300.0, 'expense': 2600.0},
    {'month': 'Oct', 'income': 3500.0, 'expense': 2890.0},
  ];

  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    double totalSpent = categoryData.fold(0, (sum, cat) => sum + cat['value']);

    return Scaffold(
      backgroundColor: Color(0xFF141821),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(title: "Insights"),
              SizedBox(height: 10),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(0xFF00F5D4).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.trending_up, color: Color(0xFF00F5D4), size: 20),
                            ),
                            SizedBox(height: 8),
                            Text("This Month", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("₹3,500", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text("+12% from last month", style: TextStyle(color: Color(0xFF00F5D4), fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GlassCard(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(0xFF0EA5FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.trending_down, color: Color(0xFF0EA5FF), size: 20),
                            ),
                            SizedBox(height: 8),
                            Text("Expenses", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("₹2,890", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text("82% of income", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Pie Chart and Legend
              GlassCard(
                
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Spending by Category", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: categoryData
                                .asMap()
                                .map((i, entry) {
                                  final bool isTouched = touchedIndex == i;
                                  final double radius = isTouched ? 60 : 50;
                                  return MapEntry(
                                    i,
                                    PieChartSectionData(
                                      color: entry['color'],
                                      value: entry['value'],
                                      title: '',
                                      radius: radius,
                                      showTitle: false,
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                            pieTouchData: PieTouchData(
                              touchCallback: (event, pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse != null &&
                                      pieTouchResponse.touchedSection != null &&
                                      event is FlTapUpEvent) {
                                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                  } else if (event is FlLongPressEnd || event is FlPanEndEvent) {
                                    touchedIndex = null;
                                  }
                                });
                              },
                            ),
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 18),

                      // Legend below chart
                      Column(
                        children: categoryData.map((category) {
                          double percent = (category['value'] / totalSpent) * 100;
                          int idx = categoryData.indexOf(category);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: category['color'],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(category['name'], style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("₹${category['value'].toStringAsFixed(0)}",
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 2),
                                    Text("${percent.toStringAsFixed(1)}%",
                                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    if (touchedIndex == idx)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        margin: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "${category['name']} • ₹${category['value']} (${percent.toStringAsFixed(1)}%)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Monthly Comparison Bar Chart
              GlassCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Monthly Comparison",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 900,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.white.withOpacity(0.05),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 34,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 1000 == 0 && value > 0 && value <= 3600) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final months = ['Jul', 'Aug', 'Sep', 'Oct'];
                                    if (value.toInt() >= 0 && value.toInt() < months.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          months[value.toInt()],
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                  reservedSize: 32,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: monthlyData.asMap().entries.map((entry) {
                              int idx = entry.key;
                              var data = entry.value;
                              return BarChartGroupData(
                                x: idx,
                                barRods: [
                                  BarChartRodData(
                                    toY: data['income'],
                                    width: 11,
                                    color: Color(0xFF00F5D4),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  BarChartRodData(
                                    toY: data['expense'],
                                    width: 11,
                                    color: Color(0xFF0EA5FF),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                ],
                                barsSpace: 6,
                              );
                            }).toList(),
                            groupsSpace: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // AI Powered Insights Card
              GlassCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF0EA5FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.lightbulb, color: Color(0xFF0EA5FF), size: 24),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AI-Powered Insights",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• Your biggest expense this month is Housing at ₹1,200 (41% of total spending)",
                                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.35),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "• You're spending 15% less on Food & Drink compared to last month",
                                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.35),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "• Consider setting a budget alert for Shopping - you've already spent 68% of your typical monthly amount",
                                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.35),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
