import 'package:aviato_finance/dummy_data.dart';
import 'package:flutter/material.dart';

class InOutDataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get data => _data;

  InOutDataProvider() {
    loadData(); // <- importante
  }

  void loadData() {
    _data = InOutUserData.value;
    notifyListeners();
  }

  void setData(List<Map<String, dynamic>> newData) {
    _data = newData;
    notifyListeners();
  }

  List<Map<String, dynamic>> get income =>
      _data.where((item) => item["amount"] >= 0).toList();

  List<Map<String, dynamic>> get outcome =>
      _data.where((item) => item["amount"] < 0).toList();

  double get totalIncome =>
      income.fold(0.0, (sum, item) => sum + (item["amount"] as num));

  double get totalOutcome =>
      outcome.fold(0.0, (sum, item) => sum + (item["amount"] as num)).abs();
}
