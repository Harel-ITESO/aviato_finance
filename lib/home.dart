
import 'package:aviato_finance/GraphPie.dart';
import 'package:aviato_finance/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:aviato_finance/screens/add_Data.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key, });


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Color customRed = Color.fromRGBO(160, 74, 67, 1);
  final Color customGreen = Color.fromRGBO(109, 120, 58, 1);
  
  int _selectedIndex = 0;

  
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
  Widget createItemList (context, index) {
    final item = InOutUserData[index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item["name"], 
            style: TextStyle(
              fontSize: 16
            ),
          ),
          Text("\$${item["amount"]}",
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

    List recentData = InOutUserData.where((item) {
      DateTime itemDate = DateTime.parse(item["date"]);
      return itemDate.isAfter(sevenDaysAgo) && itemDate.isBefore(now);
    }).toList();

    double totalIncome = recentData
        .where((item) => item["amount"] >= 0)
        .fold(0.0, (sum, item) => sum + item["amount"]);

    double totalOutcome = recentData
        .where((item) => item["amount"] < 0)
        .fold(0.0, (sum, item) => sum + item["amount"])
        .abs();

    double totalAmount = totalIncome + totalOutcome;

    double incomePercentage = totalAmount > 0 ? (totalIncome / totalAmount) * 100 : 100;
    double outcomePercentage = totalAmount > 0 ? (totalOutcome / totalAmount) * 100 : 0;
  
    final List<ChartData> chartData = [
            ChartData('Income', totalIncome, incomePercentage ,customGreen),
            ChartData('Outcome', totalOutcome, outcomePercentage ,customRed),
        ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.monetization_on_outlined, size: 40,),
            Text(" Aviato", 
              style: TextStyle(
                fontSize: 35, 
                color: customGreen
                ),
              ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(30,0,0,0),
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 40, // Aquí defines el tamaño del ícono del menú
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Color.fromRGBO(236, 236, 236, 1),
              child: Container(
                height: 370,
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Resume", 
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(108, 96, 100, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Last 7 days", 
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(108, 96, 100, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 70,), 
                        ],
                      ),
                      GraphPie(chartData: chartData)
                    ],
                  ),
                )
                ),
            ),
            Card(
              color: Color.fromRGBO(236, 236, 236, 1),
              child: Container(
                height: 250,
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("History", 
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
                            color: const Color.fromARGB(158, 255, 255, 255), // Fondo blanco para darle un aspecto plano
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color.fromARGB(70, 114, 114, 114), width: 1), // Borde suave para el efecto de incrustado
                            boxShadow: [
                              BoxShadow(
                                color: Colors.transparent, // Elimina la sombra para que no esté elevada
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,3,1.8,0),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: InOutUserData.length,
                                itemBuilder: (context, index) {
                                  InOutUserData.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
                                  return createItemList(context, index);
                                }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(169, 190, 109, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
                title: Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 40,
                    color: Colors.white,
                  )
                ),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: ListTile(
                leading: Icon(Icons.home, color: Colors.white,),
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: ListTile(
                leading: Icon(Icons.add, color: Colors.white),
                title: Text('Add', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: ListTile(
                leading: Icon(Icons.show_chart, color: Colors.white),
                title: Text('Stats', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: customGreen,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}


