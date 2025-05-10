import 'package:aviato_finance/modules/stats/exporter.dart';
import 'package:aviato_finance/utils/file_path.dart';
import 'package:intl/intl.dart';

class CsvExporter implements Exporter {
  String generateCsvContent(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  ) {
    final StringBuffer buffer = StringBuffer();
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('yyyy-MM-dd');

    // Add header for the CSV file
    buffer.writeln(
      'AVIATO FINANCE REPORT,${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
    );
    buffer.writeln('');

    // Calculate totals
    double totalIncome = income.fold(
      0.0,
      (sum, item) => sum + (item["amount"] as num),
    );

    double totalOutcome =
        outcome.fold(0.0, (sum, item) => sum + (item["amount"] as num)).abs();

    double netBalance = totalIncome + totalOutcome;

    // Add summary section
    buffer.writeln('SUMMARY');
    buffer.writeln('Total Income,${currencyFormatter.format(totalIncome)}');
    buffer.writeln('Total Expenses,${currencyFormatter.format(-totalOutcome)}');
    buffer.writeln('Net Balance,${currencyFormatter.format(netBalance)}');
    buffer.writeln('');

    // Add income details section
    buffer.writeln('INCOME DETAILS');
    buffer.writeln('Date,Name,Amount,Percentage');

    if (income.isEmpty) {
      buffer.writeln('No income records found.');
    } else {
      // Sort income by date (most recent first)
      income.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );

      // Format each income entry
      for (var entry in income) {
        String date = dateFormatter.format(DateTime.parse(entry['date']));
        String name = entry['name'];
        double amount = entry['amount'] + 0.0;
        double percentage = totalIncome > 0 ? (amount / totalIncome) * 100 : 0;

        buffer.writeln(
          '$date,$name,${currencyFormatter.format(amount)},${percentage.toStringAsFixed(2)}%',
        );
      }
    }
    buffer.writeln('');

    // Add expense details section
    buffer.writeln('EXPENSE DETAILS');
    buffer.writeln('Date,Name,Amount,Percentage');

    if (outcome.isEmpty) {
      buffer.writeln('No expense records found.');
    } else {
      // Sort expenses by date (most recent first)
      outcome.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );

      // Format each expense entry
      for (var entry in outcome) {
        String date = dateFormatter.format(DateTime.parse(entry['date']));
        String name = entry['name'];
        double amount = double.tryParse(entry['amount'].toString())!;
        double percentage =
            totalOutcome != 0 ? (amount.abs() / totalOutcome) * 100 : 0;

        buffer.writeln(
          '$date,$name,${currencyFormatter.format(amount)},${percentage.toStringAsFixed(2)}%',
        );
      }
    }

    return buffer.toString();
  }

  @override
  Future<String> export(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  ) async {
    String csvContent = generateCsvContent(income, outcome);

    final file = await getFilePath("aviato-finance-report.csv");
    print("CSV file saved to: ${file.path}");
    await file.writeAsString(csvContent);
    return file.path;
  }
}
