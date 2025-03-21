
import 'package:aviato_finance/Components/graph_pie.dart';
import 'package:aviato_finance/Components/InOutToggleButtons.dart';
import 'package:aviato_finance/Components/appBar.dart';
import 'package:aviato_finance/Components/bottomNavBar.dart';
import 'package:aviato_finance/Components/drawer.dart';
import 'package:aviato_finance/Components/globalVariables.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  switch (index) {
  case 0:
    Navigator.pushNamed(context, '/home');
    break;
  case 1:
    Navigator.pushNamed(context, '/addData');
    break;
  case 2:
    Navigator.pushNamed(context, '/stats');
    break;
  default:
    // Handle any other cases if necessary
  }
}
  
  Widget createItemList (context, index, data) {
    ChartData item = data[index];    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.pie_chart,color: item.color,),
          Text(item.x, 
            style: TextStyle(
              fontSize: 16
            ),
          ),
          Text("\$${item.y}",
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

  List<ChartData> chartData=[];
  @override
  void initState() {
    super.initState();

    // Calcular datos solo una vez cuando se crea la página
    List<Map<String, dynamic>>  listIncome = InOutUserData
        .where((item) => item["amount"] >= 0)
        .toList();
  double totalIncome = listIncome
      .fold(0.0, (sum, item) => sum + (item["amount"] as num));

    chartData = [
      ...listIncome.map((element) => ChartData(
            element["name"],
            element["amount"].toDouble(),
            element["amount"] != 0
                ? ((element["amount"] / totalIncome) * 100).abs()
                : 0,
            getUniqueColor(),
          )),
    ];
  }
  @override
  Widget build(BuildContext context) {
      setState(() {
    InOutUserData.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
  });

  // Filtrar listas
  List<Map<String, dynamic>> listIncome = InOutUserData
      .where((item) => item["amount"] >= 0)
      .toList();

  List<Map<String, dynamic>> listOutcome = InOutUserData
      .where((item) => item["amount"] < 0)
      .toList();

  // Calcular totales
  double totalIncome = listIncome
      .fold(0.0, (sum, item) => sum + (item["amount"] as num));

  double totalOutcome = listOutcome
      .fold(0.0, (sum, item) => sum + (item["amount"] as num))
      .abs();
  double totalAmount = totalIncome + totalOutcome;
  

    return Scaffold(
      appBar: AviatoAppBar(),
      bottomNavigationBar:AviatoBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      drawer: AviatoDrawer(
    onItemTapped: _onItemTapped, // La función para cambiar de página
  ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IncomeOutcomeToggle(
            onIncomeSelected: (){
              setState(() {
                chartData = [
                    ...listIncome.map((element) => ChartData(
                      element["name"], 
                      element["amount"].toDouble(), 
                      element["amount"] > 0 ? (element["amount"] / totalIncome)*100 : 0,
                      getUniqueColor(),
                    )),
                  ];
              });
            },
            onOutcomeSelected: (){
              setState(() {
                chartData = [
                  ...listOutcome.map((element) => ChartData(
                    element["name"], 
                    element["amount"].toDouble(), 
                    element["amount"] != 0 ? ((element["amount"] / totalOutcome)*100).abs() : 0,
                    getUniqueColor(),
                  )),
                ];
              });
            },
          ),
          Container(
            height: 400,
            child: GraphPie(
              chartData: chartData,
              legend: Legend(
                isVisible: false,
                ),
              shadowWidth: 310,
              shadowHeight: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Expanded(
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(158, 255, 255, 255), // Fondo blanco para darle un aspecto plano
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color.fromARGB(70, 114, 114, 114), width: 1), // Borde suave para el efecto de incrustado
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.transparent, // Elimina la sombra para que no esté elevada
                                ),
                              ],
                            ),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: chartData.length,
                                itemBuilder: (context, index) {
                                  return createItemList(context, index, chartData);
                                }
                              ),
                            ),
                          ),
                        ),
            ),
        ],
      ),
    );
  }

}