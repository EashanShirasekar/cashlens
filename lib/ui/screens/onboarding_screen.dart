import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingScreen({super.key, required this.onFinished});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0; // 0 = SMS intro, 1 = Link account
  late final bool isAndroid;
  late final bool isIOS;

  @override
  void initState() {
    super.initState();
    isAndroid = Platform.isAndroid;
    isIOS = Platform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: double.infinity,
                height: 460, // tall enough, no inner scroll needed
                decoration: BoxDecoration(
                  color: const Color(0xFF111318).withOpacity(0.98),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 36,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top teal bar
                    Container(
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E59C),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Column(
                        children: [
                          _buildTopRow(),
                          const SizedBox(height: 12),
                          _buildProgressBar(),
                          const SizedBox(height: 12),
                          _buildCenterIcon(),
                          const SizedBox(height: 16),
                          Expanded(
                            child:
                                step == 0 ? _smsIntroContent() : _linkAccountContent(),
                          ),
                          const SizedBox(height: 12),
                          _buildButtons(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Close button row
  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: widget.onFinished,
        ),
      ],
    );
  }

  // Two-step progress bar
  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF00E59C),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: step == 1
                  ? const Color(0xFF00E59C)
                  : Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }

  // Icon below the bar – phone on step 0, bank on step 1
  Widget _buildCenterIcon() {
    final iconData = step == 0 ? Icons.smartphone : Icons.account_balance;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF00E59C),
      ),
      child: Icon(iconData, color: Colors.black, size: 24),
    );
  }

  // STEP 0: SMS intro
  Widget _smsIntroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Welcome to CashLens!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            "Let's set up automatic transaction tracking",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),
        _platformCard(
          title: "Android Users",
          isHighlighted: isAndroid,
          description:
              "Grant SMS reading permission to automatically parse transaction messages from your bank.",
        ),
        const SizedBox(height: 10),
        _platformCard(
          title: "iOS Users",
          isHighlighted: isIOS,
          description:
              "Due to iOS restrictions, automatic SMS parsing is not available. You'll need to manually add transactions.",
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF3A1010),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Privacy Note: CashLens is not meant for collecting PII or securing highly sensitive data. All SMS data is processed locally on your device.",
            style: TextStyle(
              color: Colors.red.shade100,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // STEP 1: Link bank account
  Widget _linkAccountContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Link Your Bank Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            "Connect your bank accounts to track balances and transactions",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF181B23),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What you'll need:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              _checkLine("Bank account number"),
              _checkLine("UPI ID (optional, for payments)"),
              _checkLine("Login credentials (for automatic sync)"),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF00E59C).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Developer Note: This would trigger a secure bank linking flow via Plaid/Yodlee API integration or a manual entry form.",
            style: TextStyle(
              color: Color(0xFF00E59C),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // Platform card with auto highlight
  Widget _platformCard({
    required String title,
    required bool isHighlighted,
    required String description,
  }) {
    const teal = Color(0xFF00E59C);
    final borderColor =
        isHighlighted ? teal.withOpacity(0.8) : Colors.white.withOpacity(0.10);
    final iconColor =
        isHighlighted ? teal : Colors.white.withOpacity(0.45);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF181B23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00E59C), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom buttons
  Widget _buildButtons() {
    if (step == 0) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: widget.onFinished,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF181B23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.white.withOpacity(0.20)),
                ),
              ),
              child: const Text(
                "Skip for Now",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                // TODO: request SMS permission for Android here
                setState(() => step = 1);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFF00E59C),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  child: const Text(
                    "Grant Permission",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: widget.onFinished,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF181B23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.white.withOpacity(0.20)),
                ),
              ),
              child: const Text(
                "I'll Do This Later",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: open real link-account flow
                widget.onFinished();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFF00E59C),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  child: const Text(
                    "Link Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
