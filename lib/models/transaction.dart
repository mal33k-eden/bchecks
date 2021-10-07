class OwnerTransaction {
  late String uid;
  late String category;
  late String expense;
  late int amount;
  late DateTime trxDate;
  late String trxID;

  OwnerTransaction(
      {required this.uid,
      required this.category,
      required this.expense,
      required this.amount,
      required this.trxDate,
      required this.trxID});
}
