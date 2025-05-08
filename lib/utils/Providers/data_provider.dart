import 'package:aviato_finance/components/graph_pie.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';

DateTime now = DateTime.now();
DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

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




  
    List get recentData =>
            _data.where((item) {
              DateTime itemDate = DateTime.parse(item["date"]);
              return itemDate.isAfter(sevenDaysAgo) && itemDate.isBefore(now);
            }).toList();
/* 
    double get totalIncome => recentData
            .where((item) => item["amount"] >= 0)
            .fold(0.0, (sum, item) => sum + item["amount"]);

    double get totalOutcome =>
            recentData
                .where((item) => item["amount"] < 0)
                .fold(0.0, (sum, item) => sum + item["amount"])
                .abs();
 */
    double get totalAmount => totalIncome + totalOutcome;

    double get incomePercentage =>
            totalAmount > 0 ? (totalIncome / totalAmount) * 100 : 100;
    double get outcomePercentage =>
            totalAmount > 0 ? (totalOutcome / totalAmount) * 100 : 0;

    List<ChartData> get chartData_IncomeOutcome => [
          ChartData('Income', totalIncome, incomePercentage, customGreen),
          ChartData('Outcome', totalOutcome, outcomePercentage, customRed),
        ];
}



