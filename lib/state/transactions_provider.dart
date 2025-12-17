import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../services/sms_parser.dart';

class TransactionList extends StateNotifier<List<Transaction>> {
  TransactionList()
      : super([
          Transaction(id: 1, merchant: 'Starbucks Coffee', category: 'Food & Drink', amount: -5.50, date: 'Oct 10, 2025', isCredit: false),
          Transaction(id: 2, merchant: 'Uber Ride', category: 'Transport', amount: -12.30, date: 'Oct 10, 2025', isCredit: false),
          Transaction(id: 3, merchant: 'Amazon Purchase', category: 'Shopping', amount: -45.99, date: 'Oct 9, 2025', isCredit: false),
          Transaction(id: 4, merchant: 'Monthly Salary', category: 'Income', amount: 3500.00, date: 'Oct 1, 2025', isCredit: true),
          Transaction(id: 5, merchant: 'Rent Payment', category: 'Housing', amount: -1200.00, date: 'Oct 1, 2025', isCredit: false),
        ]);

  void addParsed(ParsedTransaction parsed) {
    final id = DateTime.now().millisecondsSinceEpoch;
    final dateStr = '${_monthName(parsed.date.month)} ${parsed.date.day}, ${parsed.date.year}';
    final txn = Transaction(
      id: id,
      merchant: parsed.merchant,
      category: parsed.category,
      amount: parsed.isCredit ? parsed.amount : -parsed.amount,
      date: dateStr,
      isCredit: parsed.isCredit,
    );
    state = [txn, ...state];
  }

  String _monthName(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}

final transactionsProvider = StateNotifierProvider<TransactionList, List<Transaction>>((ref) {
  return TransactionList();
});
