import 'dart:core';

class ParsedTransaction {
  final String merchant;
  final String category;
  final double amount;
  final bool isCredit;
  final DateTime date;
  ParsedTransaction({
    required this.merchant,
    required this.category,
    required this.amount,
    required this.isCredit,
    required this.date,
  });
}

class SmsParser {
  static ParsedTransaction? parse(String body) {
    final text = body.trim();
    if (text.isEmpty) return null;
    final amountMatch = RegExp(r'(INR|Rs\.?)\s?([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false).firstMatch(text);
    if (amountMatch == null) return null;
    final amountStr = amountMatch.group(2)!.replaceAll(',', '');
    final amount = double.tryParse(amountStr);
    if (amount == null) return null;
    final isCredit = _isCredit(text);
    final merchant = _extractMerchant(text);
    final category = _inferCategory(text, isCredit);
    return ParsedTransaction(
      merchant: merchant,
      category: category,
      amount: amount,
      isCredit: isCredit,
      date: DateTime.now(),
    );
  }

  static bool _isCredit(String text) {
    final t = text.toLowerCase();
    if (t.contains('credited') || t.contains('received') || t.contains('deposit')) return true;
    if (t.contains('debited') || t.contains('spent') || t.contains('purchase') || t.contains('withdrawal')) return false;
    return t.contains('upi') && !t.contains('declined');
  }

  static String _extractMerchant(String text) {
    final patterns = [
      RegExp(r'\bat\s+([A-Za-z0-9 &._-]+)', caseSensitive: false),
      RegExp(r'\bfrom\s+([A-Za-z0-9 &._-]+)', caseSensitive: false),
      RegExp(r'\bto\s+([A-Za-z0-9 &._-]+)', caseSensitive: false),
      RegExp(r'\bby\s+([A-Za-z0-9 &._-]+)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(text);
      if (m != null) {
        final name = m.group(1)!.trim();
        return name.length > 2 ? name : 'Merchant';
      }
    }
    final upi = RegExp(r'([A-Za-z0-9._-]+@[A-Za-z0-9._-]+)').firstMatch(text);
    if (upi != null) return upi.group(1)!.trim();
    return 'Merchant';
  }

  static String _inferCategory(String text, bool isCredit) {
    final t = text.toLowerCase();
    if (t.contains('upi')) return 'UPI';
    if (t.contains('atm')) return 'ATM';
    if (t.contains('pos') || t.contains('purchase')) return 'Shopping';
    if (t.contains('salary') || t.contains('credited') || t.contains('received')) return isCredit ? 'Salary' : 'Income';
    if (t.contains('gas') || t.contains('fuel')) return 'Transport';
    if (t.contains('food') || t.contains('restaurant') || t.contains('dining')) return 'Food & Drink';
    return isCredit ? 'Income' : 'Expense';
  }
}
