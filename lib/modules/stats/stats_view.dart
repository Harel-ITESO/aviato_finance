import 'package:aviato_finance/components/graph_pie.dart';
import 'package:aviato_finance/components/income_outcome_toggle.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/modules/stats/export_options_dialog.dart';
import 'package:aviato_finance/modules/stats/exporter_enum.dart';
import 'package:aviato_finance/modules/stats/exporter_factory.dart';
import 'package:aviato_finance/utils/colors.dart' hide getUniqueColor;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  Widget createItemList(context, index, data) {
    ChartData item = data[index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.pie_chart, color: item.color),
          Text(item.x, style: TextStyle(fontSize: 16)),
          Text(
            "\$${item.y}",
            style: TextStyle(
              fontSize: 16,
              color: item.y < 0 ? customRed : customGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> chartData = [];
  @override
  void initState() {
    super.initState();

    // Calcular datos solo una vez cuando se crea la página
    List<Map<String, dynamic>> listIncome =
        InOutUserData.where((item) => item["amount"] >= 0).toList();
    double totalIncome = listIncome.fold(
      0.0,
      (sum, item) => sum + (item["amount"] as num),
    );

    chartData = [
      ...listIncome.map(
        (element) => ChartData(
          element["name"],
          element["amount"].toDouble(),
          element["amount"] != 0
              ? ((element["amount"] / totalIncome) * 100).abs()
              : 0,
          getUniqueColor(),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      InOutUserData.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );
    });

    // Filtrar listas
    List<Map<String, dynamic>> listIncome =
        InOutUserData.where((item) => item["amount"] >= 0).toList();

    List<Map<String, dynamic>> listOutcome =
        InOutUserData.where((item) => item["amount"] < 0).toList();

    // Calcular totales
    double totalIncome = listIncome.fold(
      0.0,
      (sum, item) => sum + (item["amount"] as num),
    );

    double totalOutcome =
        listOutcome
            .fold(0.0, (sum, item) => sum + (item["amount"] as num))
            .abs();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 50),
            IncomeOutcomeToggle(
              onIncomeSelected: () {
                setState(() {
                  chartData = [
                    ...listIncome.map(
                      (element) => ChartData(
                        element["name"],
                        element["amount"].toDouble(),
                        element["amount"] > 0
                            ? (element["amount"] / totalIncome) * 100
                            : 0,
                        getUniqueColor(),
                      ),
                    ),
                  ];
                });
              },
              onOutcomeSelected: () {
                setState(() {
                  chartData = [
                    ...listOutcome.map(
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
                });
              },
            ),
            IconButton(
              onPressed:
                  () => showExportDialogOptions(context, (
                    SelectedExporter e,
                  ) async {
                    var exporter = ExporterFactory.getExporter(e);
                    await exporter.export(listIncome, listOutcome);
                  }),
              icon: Icon(Icons.save),
              color: customGreen,
              iconSize: 35,
            ),
          ],
        ),
        SizedBox(
          height: 400,
          child: GraphPie(
            chartData: chartData,
            legend: Legend(isVisible: false),
            shadowWidth: 310,
            shadowHeight: 300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                158,
                255,
                255,
                255,
              ), // Fondo blanco para darle un aspecto plano
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(70, 114, 114, 114),
                width: 1,
              ), // Borde suave para el efecto de incrustado
              boxShadow: [
                BoxShadow(
                  color:
                      Colors
                          .transparent, // Elimina la sombra para que no esté elevada
                ),
              ],
            ),
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  return createItemList(context, index, chartData);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
