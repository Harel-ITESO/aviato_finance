import 'package:aviato_finance/components/graph_pie.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget createItemList(context, index) {
    final item = InOutUserData[index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item["name"], style: TextStyle(fontSize: 16)),
          Text(
            "\$${item["amount"]}",
            style: TextStyle(
              fontSize: 16,
              color: item["amount"] < 0 ? customRed : customGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    List recentData =
        InOutUserData.where((item) {
          DateTime itemDate = DateTime.parse(item["date"]);
          return itemDate.isAfter(sevenDaysAgo) && itemDate.isBefore(now);
        }).toList();

    double totalIncome = recentData
        .where((item) => item["amount"] >= 0)
        .fold(0.0, (sum, item) => sum + item["amount"]);

    double totalOutcome =
        recentData
            .where((item) => item["amount"] < 0)
            .fold(0.0, (sum, item) => sum + item["amount"])
            .abs();

    double totalAmount = totalIncome + totalOutcome;

    double incomePercentage =
        totalAmount > 0 ? (totalIncome / totalAmount) * 100 : 100;
    double outcomePercentage =
        totalAmount > 0 ? (totalOutcome / totalAmount) * 100 : 0;

    final List<ChartData> chartData = [
      ChartData('Income', totalIncome, incomePercentage, customGreen),
      ChartData('Outcome', totalOutcome, outcomePercentage, customRed),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            color: Color.fromRGBO(236, 236, 236, 1),
            child: SizedBox(
              height: 370,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Resume",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(108, 96, 100, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Last 7 days",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(108, 96, 100, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 70),
                      ],
                    ),
                    GraphPie(
                      chartData: chartData,
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Color.fromRGBO(236, 236, 236, 1),
            child: SizedBox(
              height: 250,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(108, 96, 100, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Container(
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 1.8, 0),
                          child: Scrollbar(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: InOutUserData.length,
                              itemBuilder: (context, index) {
                                InOutUserData.sort(
                                  (a, b) => DateTime.parse(
                                    b['date'],
                                  ).compareTo(DateTime.parse(a['date'])),
                                );
                                return createItemList(context, index);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
