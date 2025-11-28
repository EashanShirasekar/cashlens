class Transaction {
  final int id;
  final String merchant;
  final String category;
  final double amount;
  final String date;
  final bool isCredit;

  Transaction({
    required this.id,
    required this.merchant,
    required this.category,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}
