import 'package:flutter/foundation.dart';
import '../models/bill_model.dart';
import '../services/database_service.dart';
import '../services/preferences_service.dart';

class BillProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final PreferencesService _prefsService = PreferencesService();

  // --- Bill State ---
  double _billAmount = 0.0;
  int _numberOfPeople = 2;
  double _tipPercentage = 15.0;
  String _currency = 'Rs.';

  // --- History ---
  List<BillModel> _billHistory = [];

  // --- Settings ---
  double _defaultTip = 15.0;
  int _defaultPeople = 2;

  // Getters
  double get billAmount => _billAmount;
  int get numberOfPeople => _numberOfPeople;
  double get tipPercentage => _tipPercentage;
  String get currency => _currency;
  List<BillModel> get billHistory => _billHistory;
  double get defaultTip => _defaultTip;
  int get defaultPeople => _defaultPeople;

  double get tipAmount => _billAmount * (_tipPercentage / 100);
  double get totalAmount => _billAmount + tipAmount;
  double get perPersonAmount =>
      _numberOfPeople > 0 ? totalAmount / _numberOfPeople : 0.0;

  // Initialize
  Future<void> init() async {
    _currency = await _prefsService.getCurrency();
    _defaultTip = await _prefsService.getDefaultTip();
    _defaultPeople = await _prefsService.getDefaultPeople();
    _tipPercentage = _defaultTip;
    _numberOfPeople = _defaultPeople;
    await loadHistory();
    notifyListeners();
  }

  // Setters
  void setBillAmount(double amount) {
    _billAmount = amount;
    notifyListeners();
  }

  void setNumberOfPeople(int people) {
    if (people >= 1 && people <= 20) {
      _numberOfPeople = people;
      notifyListeners();
    }
  }

  void setTipPercentage(double tip) {
    _tipPercentage = tip;
    notifyListeners();
  }

  void reset() {
    _billAmount = 0.0;
    _numberOfPeople = _defaultPeople;
    _tipPercentage = _defaultTip;
    notifyListeners();
  }

  // Save to SQLite
  Future<void> saveBill(String title) async {
    final bill = BillModel(
      title: title,
      billAmount: _billAmount,
      numberOfPeople: _numberOfPeople,
      tipPercentage: _tipPercentage,
      totalAmount: totalAmount,
      perPersonAmount: perPersonAmount,
      date: DateTime.now().toString().substring(0, 16),
    );
    await _dbService.insertBill(bill);
    await loadHistory();
  }

  // Load history
  Future<void> loadHistory() async {
    _billHistory = await _dbService.getAllBills();
    notifyListeners();
  }

  // Delete bill
  Future<void> deleteBill(int id) async {
    await _dbService.deleteBill(id);
    await loadHistory();
  }

  // Delete all
  Future<void> deleteAllBills() async {
    await _dbService.deleteAllBills();
    await loadHistory();
  }

  // Settings
  Future<void> updateCurrency(String currency) async {
    _currency = currency;
    await _prefsService.setCurrency(currency);
    notifyListeners();
  }

  Future<void> updateDefaultTip(double tip) async {
    _defaultTip = tip;
    _tipPercentage = tip;
    await _prefsService.setDefaultTip(tip);
    notifyListeners();
  }

  Future<void> updateDefaultPeople(int people) async {
    _defaultPeople = people;
    _numberOfPeople = people;
    await _prefsService.setDefaultPeople(people);
    notifyListeners();
  }
}
