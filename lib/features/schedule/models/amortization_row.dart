class AmortizationRow {
  final int period;
  final DateTime date;
  final double payment;
  final double principal;
  final double interest;
  final double balance;

  const AmortizationRow({
    required this.period,
    required this.date,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}
