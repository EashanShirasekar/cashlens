import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/glass_card.dart';

class Goal {
  final int id;
  final String goalName;
  final String icon;
  final Color color;
  final double savedAmount;
  final double targetAmount;
  final double autoSaveAmount;
  final DateTime deadline;
  final bool autoSaveEnabled;

  Goal({
    required this.id,
    required this.goalName,
    required this.icon,
    required this.color,
    required this.savedAmount,
    required this.targetAmount,
    required this.autoSaveAmount,
    required this.deadline,
    required this.autoSaveEnabled,
  });
}

class GoalsScreen extends StatelessWidget {
  final List<Goal> goals = [
    Goal(
      id: 1,
      goalName: 'Emergency Fund',
      icon: 'ShieldCheck',
      color: Color(0xFF00F5D4),
      savedAmount: 32500,
      targetAmount: 50000,
      autoSaveAmount: 2000,
      deadline: DateTime(2025, 12, 31),
      autoSaveEnabled: true,
    ),
    Goal(
      id: 2,
      goalName: 'Vacation to Maldives',
      icon: 'Plane',
      color: Color(0xFF00A3FF),
      savedAmount: 45000,
      targetAmount: 80000,
      autoSaveAmount: 0,
      deadline: DateTime(2026, 6, 30),
      autoSaveEnabled: false,
    ),
    Goal(
      id: 3,
      goalName: 'New Laptop',
      icon: 'Laptop',
      color: Color(0xFF8B5CF6),
      savedAmount: 60000,
      targetAmount: 120000,
      autoSaveAmount: 5000,
      deadline: DateTime(2026, 3, 31),
      autoSaveEnabled: true,
    ),
  ];

  int calculateMonthsLeft(Goal goal) {
    if (!goal.autoSaveEnabled || goal.autoSaveAmount == 0) return 0;
    final monthsLeft = ((goal.targetAmount - goal.savedAmount) / goal.autoSaveAmount).ceil();
    return monthsLeft > 0 ? monthsLeft : 0;
  }

  double calculateProgress(Goal goal) {
    return (goal.savedAmount / goal.targetAmount).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    double totalSaved = goals.fold(0, (sum, g) => sum + g.savedAmount);
    double totalTarget = goals.fold(0, (sum, g) => sum + g.targetAmount);
    double totalMonthly = goals.fold(0, (sum, g) => sum + g.autoSaveAmount);
    double avgProgress = totalTarget == 0 ? 0 : totalSaved / totalTarget;

    return Scaffold(
      backgroundColor: Color(0xFF141821),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(title: 'Goals'),
              SizedBox(height: 10),

              // Developer Note
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Developer Note: Data from Firestore → goals collection.\n"
                    "Query: db.collection('goals').where('userId','==', uid).\n"
                    "Progress = savedAmount/targetAmount. Auto-save enabled via linked accounts.",
                    style: TextStyle(color: Colors.tealAccent.shade100.withOpacity(0.7), fontSize: 12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Goals List
              Column(
                children: goals.map((goal) {
                  final progress = calculateProgress(goal);
                  final monthsLeft = calculateMonthsLeft(goal);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassCard(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icons and Title Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: goal.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getIconData(goal.icon),
                                        color: goal.color,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(goal.goalName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        SizedBox(height: 4),
                                        Text(
                                          monthsLeft > 0
                                              ? "$monthsLeft months left"
                                              : "Manual contributions",
                                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (goal.autoSaveEnabled)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: goal.color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      "Auto-save",
                                      style: TextStyle(
                                          color: goal.color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Circular Progress Indicator
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 10,
                                      color: goal.color,
                                      backgroundColor: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${(progress * 100).toStringAsFixed(0)}%",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("complete",
                                          style: TextStyle(
                                              color: Colors.grey[400], fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            // Progress details
                            _progressDetailRow("Current", "₹${goal.savedAmount.toStringAsFixed(0)}"),
                            _progressDetailRow("Target", "₹${goal.targetAmount.toStringAsFixed(0)}"),
                            if (goal.autoSaveEnabled)
                              _progressDetailRow("Monthly Auto-save",
                                TextSpan(text: "₹${goal.autoSaveAmount.toStringAsFixed(0)}", style: TextStyle(color: goal.color))),
                            _progressDetailRow("Deadline",
                                "${goal.deadline.month}/${goal.deadline.day}/${goal.deadline.year}"),

                            SizedBox(height: 12),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: progress,
                                color: goal.color,
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 16),

              // Summary Card as a two-column grid just like your screenshot
              GlassCard(
                
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Summary",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          // Left Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Saved", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                SizedBox(height: 2),
                                Text(
                                  "₹${totalSaved.toStringAsFixed(0)}",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 12),
                                Text("Monthly", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                SizedBox(height: 2),
                                Text(
                                  "₹${totalMonthly.toStringAsFixed(0)}",
                                  style: TextStyle(
                                      color: Color(0xFF00F5D4), fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          // Right Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Total Target", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                SizedBox(height: 2),
                                Text(
                                  "₹${totalTarget.toStringAsFixed(0)}",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 12),
                                Text("Avg Progress", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                SizedBox(height: 2),
                                Text(
                                  "${(avgProgress * 100).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                      color: Color(0xFF0EA5FF), fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Add New Goal Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1, style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xFF00F5D4), size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Add New Goal",
                      style: TextStyle(color: Colors.grey[400], fontSize: 18),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          value is String
              ? Text(value, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))
              : RichText(text: value),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "Umbrella":
        return Icons.umbrella;
      case "Plane":
        return Icons.flight;
      case "Home":
        return Icons.home;
      case "GraduationCap":
        return Icons.school;
      case "ShieldCheck":
        return Icons.shield;
      case "Laptop":
        return Icons.laptop;
      default:
        return Icons.shield;
    }
  }
}
