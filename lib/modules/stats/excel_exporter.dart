import 'package:aviato_finance/modules/stats/exporter.dart';
import 'package:aviato_finance/utils/file_path.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ExcelExporter implements Exporter {
  Excel generateExcelContent(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  ) {
    final excel = Excel.createExcel();
    final summarySheet = excel['Summary'];
    final incomeSheet = excel['Income Details'];
    final outcomeSheet = excel['Expense Details'];

    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM dd, yyyy');

    // Calculate totals
    double totalIncome = income.fold(
      0.0,
      (sum, item) => sum + (item["amount"] as num),
    );

    double totalOutcome =
        outcome.fold(0.0, (sum, item) => sum + (item["amount"] as num)).abs();

    double netBalance = totalIncome + totalOutcome;

    // Create header styles
    var headerStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#4CAF50'),
      horizontalAlign: HorizontalAlign.Center,
    );

    var subHeaderStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.fromHexString('#000000'),
      backgroundColorHex: ExcelColor.fromHexString('#E8F5E9'),
    );

    // Summary Sheet
    var cell = summarySheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('AVIATO FINANCE REPORT');
    cell.cellStyle = headerStyle;

    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
        .value = TextCellValue('Generated on ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}');

    cell = summarySheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 3));
    cell.value = TextCellValue('SUMMARY');
    cell.cellStyle = subHeaderStyle;

    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4))
        .value = TextCellValue('Total Income');
    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4))
        .value = TextCellValue(currencyFormatter.format(totalIncome));

    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 5))
        .value = TextCellValue('Total Expenses');
    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 5))
        .value = TextCellValue(currencyFormatter.format(-totalOutcome));

    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 6))
        .value = TextCellValue('Net Balance');
    summarySheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 6))
        .value = TextCellValue(currencyFormatter.format(netBalance));

    // Income Sheet Headers
    cell = incomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('Date');
    cell.cellStyle = headerStyle;
    
    cell = incomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    cell.value = TextCellValue('Name');
    cell.cellStyle = headerStyle;
    
    cell = incomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
    cell.value = TextCellValue('Amount');
    cell.cellStyle = headerStyle;
    
    cell = incomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    cell.value = TextCellValue('Percentage');
    cell.cellStyle = headerStyle;

    // Add income data
    if (income.isNotEmpty) {
      // Sort income by date (most recent first)
      income.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );

      // Add each income entry
      for (int i = 0; i < income.length; i++) {
        var entry = income[i];
        String date = dateFormatter.format(DateTime.parse(entry['date']));
        String name = entry['name'];
        double amount = entry['amount'] + 0.0;
        double percentage = totalIncome > 0 ? (amount / totalIncome) * 100 : 0;

        incomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
            .value = TextCellValue(date);
        incomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
            .value = TextCellValue(name);
        incomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
            .value = DoubleCellValue(amount);
        incomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
            .value = TextCellValue('${percentage.toStringAsFixed(2)}%');
      }
    } else {
      incomeSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
          .value = TextCellValue('No income records found.');
    }

    // Expense Sheet Headers
    cell = outcomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue('Date');
    cell.cellStyle = headerStyle;
    
    cell = outcomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    cell.value = TextCellValue('Name');
    cell.cellStyle = headerStyle;
    
    cell = outcomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
    cell.value = TextCellValue('Amount');
    cell.cellStyle = headerStyle;
    
    cell = outcomeSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    cell.value = TextCellValue('Percentage');
    cell.cellStyle = headerStyle;

    // Add expense data
    if (outcome.isNotEmpty) {
      // Sort expenses by date (most recent first)
      outcome.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );

      // Add each expense entry
      for (int i = 0; i < outcome.length; i++) {
        var entry = outcome[i];
        String date = dateFormatter.format(DateTime.parse(entry['date']));
        String name = entry['name'];
        double amount = double.tryParse(entry['amount'].toString()) ?? 0.0;
        double percentage =
            totalOutcome != 0 ? (amount.abs() / totalOutcome) * 100 : 0;

        outcomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
            .value = TextCellValue(date);
        outcomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
            .value = TextCellValue(name);
        outcomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
            .value = DoubleCellValue(amount);
        outcomeSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
            .value = TextCellValue('${percentage.toStringAsFixed(2)}%');
      }
    } else {
      outcomeSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
          .value = TextCellValue('No expense records found.');
    }

    // Set column widths for better readability
    for (var sheet in [summarySheet, incomeSheet, outcomeSheet]) {
      sheet.setColumnWidth(0, 20);
      sheet.setColumnWidth(1, 25);
      sheet.setColumnWidth(2, 15);
      sheet.setColumnWidth(3, 15);
    }

    // Remove the default sheet
    excel.delete('Sheet1');

    return excel;
  }

  @override
  Future<void> export(
    List<Map<String, dynamic>> income,
    List<Map<String, dynamic>> outcome,
  ) async {
    Excel excel = generateExcelContent(income, outcome);

    final file = await getFilePath("aviato-finance-report.xlsx");
    print("Excel file saved to: ${file.path}");
    await file.writeAsBytes(excel.encode()!);
  }
}
