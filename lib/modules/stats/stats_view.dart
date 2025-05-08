import 'package:aviato_finance/components/graph_pie.dart';
import 'package:aviato_finance/components/income_outcome_toggle.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/modules/stats/export_options_dialog.dart';
import 'package:aviato_finance/modules/stats/exporter_enum.dart';
import 'package:aviato_finance/modules/stats/exporter_factory.dart';
import 'package:aviato_finance/utils/Providers/data_provider.dart';
import 'package:aviato_finance/utils/colors.dart' hide getUniqueColor;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
    getData(context); 
    });

    getData(context);
    // Calcular datos solo una vez cuando se crea la página
    List<Map<String, dynamic>> listIncome =
        InOutUserData.value.where((item) => item["amount"] >= 0).toList();
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

  var _isSelectedIncome= true;
  @override
Widget build(BuildContext context) {
  final provider = Provider.of<InOutDataProvider>(context);
  final listIncome = provider.income;
  final listOutcome = provider.outcome;
  final totalIncome = provider.totalIncome;
  final totalOutcome = provider.totalOutcome;

  if (_isSelectedIncome){
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
  }else{
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
  }
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
                  _isSelectedIncome=true;
                });
              },
              onOutcomeSelected: () {
                setState(() {
                  _isSelectedIncome=false;
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
              color:  const Color.fromARGB(
                20,
                255,
                255,
                255,
              ),  // Fondo blanco para darle un aspecto plano
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
