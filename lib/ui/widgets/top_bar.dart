import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({super.key, this.title = 'CashLens'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xFF00F5D4), Color(0xFF0EA5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text("C", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
                ),
              ),
              SizedBox(width: 12),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            ],
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle
            ),
            child: Icon(Icons.person, color: Color(0xFF00F5D4), size: 22),
          ),
        ],
      ),
    );
  }
}
