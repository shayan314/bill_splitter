class BillModel {
  final int? id;
  final String title;
  final double billAmount;
  final int numberOfPeople;
  final double tipPercentage;
  final double totalAmount;
  final double perPersonAmount;
  final String date;

  BillModel({
    this.id,
    required this.title,
    required this.billAmount,
    required this.numberOfPeople,
    required this.tipPercentage,
    required this.totalAmount,
    required this.perPersonAmount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'billAmount': billAmount,
      'numberOfPeople': numberOfPeople,
      'tipPercentage': tipPercentage,
      'totalAmount': totalAmount,
      'perPersonAmount': perPersonAmount,
      'date': date,
    };
  }

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      title: map['title'],
      billAmount: map['billAmount'],
      numberOfPeople: map['numberOfPeople'],
      tipPercentage: map['tipPercentage'],
      totalAmount: map['totalAmount'],
      perPersonAmount: map['perPersonAmount'],
      date: map['date'],
    );
  }
}
