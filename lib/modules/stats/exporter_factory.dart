import 'package:aviato_finance/modules/stats/csv_exporter.dart';
import 'package:aviato_finance/modules/stats/excel_exporter.dart';
import 'package:aviato_finance/modules/stats/exporter.dart';
import 'package:aviato_finance/modules/stats/exporter_enum.dart';
import 'package:aviato_finance/modules/stats/pdf_exporter.dart';

abstract class ExporterFactory {
  static Exporter getExporter(SelectedExporter type) {
    switch (type) {
      case SelectedExporter.pdf:
        return PdfExporter();
      case SelectedExporter.excel:
        return ExcelExporter();
      case SelectedExporter.csv:
        return CsvExporter();
    }
  }
}
