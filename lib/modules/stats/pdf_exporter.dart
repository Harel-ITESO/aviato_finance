import 'package:aviato_finance/modules/stats/exporter.dart';
import 'package:aviato_finance/utils/file_path.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfExporter implements Exporter {
  String getTextStringFormatted(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  ) {
    final StringBuffer buffer = StringBuffer();
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM dd, yyyy');

    // Add report header
    buffer.writeln('AVIATO FINANCE REPORT');
    buffer.writeln(
      'Generated on ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
    );
    buffer.writeln('----------------------------------------');

    // Calculate totals
    double totalIncome = income.fold(
      0.0,
      (sum, item) => sum + (item["amount"] as num),
    );

    double totalOutcome =
        outcome.fold(0.0, (sum, item) => sum + (item["amount"] as num)).abs();

    double netBalance = totalIncome + totalOutcome;

    // Add summary section
    buffer.writeln('\nSUMMARY');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Total Income: ${currencyFormatter.format(totalIncome)}');
    buffer.writeln(
      'Total Expenses: ${currencyFormatter.format(-totalOutcome)}',
    );
    buffer.writeln('Net Balance: ${currencyFormatter.format(netBalance)}');

    // Add income details section
    buffer.writeln('\nINCOME DETAILS');
    buffer.writeln('----------------------------------------');

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

        buffer.writeln('$name ($date)');
        buffer.writeln('  Amount: ${currencyFormatter.format(amount)}');
        buffer.writeln(
          '  Percentage of Total Income: ${percentage.toStringAsFixed(2)}%',
        );
        buffer.writeln('');
      }
    }

    // Add expense details section
    buffer.writeln('\nEXPENSE DETAILS');
    buffer.writeln('----------------------------------------');

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

        buffer.writeln('$name ($date)');
        buffer.writeln('  Amount: ${currencyFormatter.format(amount)}');
        buffer.writeln(
          '  Percentage of Total Expenses: ${percentage.toStringAsFixed(2)}%',
        );
        buffer.writeln('');
      }
    }

    // Add footer
    buffer.writeln('----------------------------------------');
    buffer.writeln('End of Report');

    return buffer.toString();
  }

  Future<String> generatePdfAndStore(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Text(text));
        },
      ),
    );

    final file = await getFilePath("generated-finance.pdf");
    print(file.path);
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  @override
  Future<String> export(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  ) async {
    String formattedText = getTextStringFormatted(income, outcome);
    var path = await generatePdfAndStore(formattedText);
    return path;
  }
}
