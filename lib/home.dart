import 'dart:ui';

import 'package:aviato_finance/components/graph_pie.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:aviato_finance/utils/Providers/data_provider.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget createItemList(context, index, List<Map<String, dynamic>> data) {
    final item = data[index];
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
      getData(context);
      return Consumer<InOutDataProvider>(
        builder: (context, provider, child) {

        final sortedData = [...provider.data];
        sortedData.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
        final chartData =  [...provider.chartData_IncomeOutcome];

        Color titleColor= Color.from(alpha:Theme.of(context).colorScheme.onSurface.a+70,red:Theme.of(context).colorScheme.onSurface.r*.9,green:Theme.of(context).colorScheme.onSurface.g*.9,blue:Theme.of(context).colorScheme.onSurface.b*.9); 
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Theme.of(context).colorScheme.onInverseSurface,//Color.fromRGBO(236, 236, 236, 1),
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
                                color: titleColor , //Color.fromRGBO(108, 96, 100, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Last 7 days",
                              style: TextStyle(
                                fontSize: 20,
                                color: titleColor,
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
                color: Theme.of(context).colorScheme.onInverseSurface,//Color.fromRGBO(236, 236, 236, 1),
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
                            color: titleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:  Theme.of(context).colorScheme.onInverseSurface,/* const Color.fromARGB(
                                20,
                                255,
                                255,
                                255,
                              ), */  // Fondo blanco para darle un aspecto plano
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(70, 114, 114, 114),
                                width: .5,
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
                                  itemCount: sortedData.length,
                                  itemBuilder: (context, index) {
                                    return createItemList(context, index, sortedData);
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
      },
    );
  }
}
