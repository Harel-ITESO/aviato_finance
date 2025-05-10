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

  List<ChartData> getOutcomeByTag(String selectedOption) {
    final Map<String, double> tagTotals = {};
    var opt = -1;
    if (selectedOption == "Category") {
      opt = 0;
    } else if (selectedOption == "Payment Method") {
      opt = 1;
    } else if (selectedOption == "Repeat") {
      opt = 2;
    }
    if (opt == -1) {
      return [
        ...outcome.map(
          (element) => ChartData(
            element["name"],
            element["amount"].toDouble(),
            element["amount"] != 0
                ? ((element["amount"] / totalOutcome) * 100).abs()
                : 0,
            getUniqueColor(),
          ),
        ),
      ];
    }

    for (var item in outcome) {
      final double amount = item["amount"].toDouble().abs();
      final List tags = [item["tags"][opt]];

      for (var tag in tags) {
        if (tag == "" || tag == " ")
          tagTotals["Unregistered"] = (tagTotals[tag] ?? 0) + amount;
        else
          tagTotals[tag] = (tagTotals[tag] ?? 0) + amount;
      }
    }
    final double total = tagTotals.values.fold(0.0, (a, b) => a + b);

    return tagTotals.entries.map((entry) {
      final String tag = entry.key;
      final double amount = -entry.value;
      final double percentage = total > 0 ? (amount / total) * 100 : 0;
      return ChartData(tag, amount, percentage, getUniqueColor());
    }).toList();
  }

  List<ChartData> getIncomeByTag(String selectedOption) {
    final Map<String, double> tagTotals = {};
    var opt = -1;
    if (selectedOption == "Category") {
      opt = 0;
    } else if (selectedOption == "Payment Method") {
      opt = 1;
    } else if (selectedOption == "Repeat") {
      opt = 2;
    }
    if (opt == -1) {
      return [
        ...income.map(
          (element) => ChartData(
            element["name"],
            element["amount"].toDouble(),
            element["amount"] != 0
                ? ((element["amount"] / totalOutcome) * 100).abs()
                : 0,
            getUniqueColor(),
          ),
        ),
      ];
    }

    for (var item in income) {
      final double amount = item["amount"].toDouble();
      final List tags = [item["tags"][opt]];

      for (var tag in tags) {
        if (tag == "")
          tagTotals["Unregistered"] = (tagTotals[tag] ?? 0) + amount;
        else
          tagTotals[tag] = (tagTotals[tag] ?? 0) + amount;
      }
    }
    final double total = tagTotals.values.fold(0.0, (a, b) => a + b);

    return tagTotals.entries.map((entry) {
      final String tag = entry.key;
      final double amount = entry.value;
      final double percentage = total > 0 ? (amount / total) * 100 : 0;
      return ChartData(tag, amount, percentage, getUniqueColor());
    }).toList();
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

  double get totalAmount => totalIncome - totalOutcome;

  double get incomePercentage =>
      totalAmount > 0 ? (totalIncome / totalAmount) * 100 : 100;
  double get outcomePercentage =>
      totalAmount > 0 ? (totalOutcome / totalAmount) * 100 : 0;

  List<ChartData> get chartData_IncomeOutcome => [
    ChartData('Income', totalIncome, incomePercentage, customGreen),
    ChartData('Expenses', totalOutcome, outcomePercentage, customRed),
  ];
}
