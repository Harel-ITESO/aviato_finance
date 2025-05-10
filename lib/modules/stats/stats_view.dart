import 'package:aviato_finance/components/graph_pie.dart';
import 'package:aviato_finance/components/income_outcome_toggle.dart';
import 'package:aviato_finance/modules/stats/export_options_dialog.dart';
import 'package:aviato_finance/modules/stats/exporter_enum.dart';
import 'package:aviato_finance/modules/stats/exporter_factory.dart';
import 'package:aviato_finance/utils/Providers/data_provider.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<ChartData> chartData = [];
  var _isSelectedIncome = true;
  final AuthService authS = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData(context);
    });
  }

  Future<void> getData(BuildContext context) async {
    var userEmail = authS.currentUser?.email;
    CollectionReference data = FirebaseFirestore.instance.collection(
      'InOutUserData',
    );

    try {
      final snapshot = await data.get();
      final List<Map<String, dynamic>> allData = [];

      for (var doc in snapshot.docs) {
        if (userEmail == doc.id) {
          Map<String, dynamic> decoded = doc.data() as Map<String, dynamic>;
          allData.addAll(List<Map<String, dynamic>>.from(decoded['Data']));
        }
      }

      Provider.of<InOutDataProvider>(context, listen: false).setData(allData);
    } catch (error) {
      print("Error fetching: $error");
    }
  }

  Future<void> updateData(
    String userDocId,
    int indexToUpdate,
    String newName,
    double newAmount,
  ) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(
      'InOutUserData',
    );

    try {
      DocumentSnapshot doc = await collection.doc(userDocId).get();
      if (doc.exists) {
        List<dynamic> dataList = (doc.data() as Map<String, dynamic>)['Data'];
        if (indexToUpdate < dataList.length) {
          dataList[indexToUpdate]['name'] = newName;
          dataList[indexToUpdate]['amount'] = newAmount;

          await collection.doc(userDocId).update({'Data': dataList});
          print("Item updated successfully!");
        }
      }
    } catch (e) {
      print("Failed to update data: $e");
    }
  }

  Future<void> deleteData(String userDocId, int indexToDelete) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(
      'InOutUserData',
    );

    try {
      DocumentSnapshot doc = await collection.doc(userDocId).get();
      if (doc.exists) {
        List<dynamic> currentData =
            (doc.data() as Map<String, dynamic>)['Data'];
        currentData.removeAt(indexToDelete);

        await collection.doc(userDocId).update({'Data': currentData});
        print("Item deleted successfully!");
      }
    } catch (e) {
      print("Failed to delete data: $e");
    }
  }

  Widget createItemList(
    BuildContext context,
    int index,
    List<ChartData> data,
    List<Map<String, dynamic>> rawList,
  ) {
    ChartData item = data[index];

    return Dismissible(
      key: Key(item.x + index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        final userEmail = authS.currentUser?.email;
        if (userEmail != null) {
          await deleteData(userEmail, index);
          await getData(context);
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${item.x} Deleted')));
      },
      child: InkWell(
        onTap: () async {
          if (selectedOption != "None") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("To edit, remove the filter.")),
            );
            return;
          }
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) {
              final nameController = TextEditingController(text: item.x);
              final amountController = TextEditingController(
                text: item.y.toString(),
              );

              return AlertDialog(
                title: const Text('Edit item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Exit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'name': nameController.text,
                        'amount': double.tryParse(amountController.text) ?? 0.0,
                      });
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );

          if (result != null) {
            final userEmail = authS.currentUser?.email;
            if (userEmail != null) {
              await updateData(
                userEmail,
                index,
                result['name'],
                result['amount'],
              );
              await getData(context);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.pie_chart, color: item.color),
              Text(item.x, style: const TextStyle(fontSize: 16)),
              Text(
                "\$${item.y.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  color: item.y < 0 ? customRed : customGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String selectedOption = 'Category';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InOutDataProvider>(context);
    final listIncome = provider.income;
    final listOutcome = provider.outcome;
    final totalIncome = provider.totalIncome;
    final totalOutcome = provider.totalOutcome;

    List<Map<String, dynamic>> rawList =
        _isSelectedIncome ? listIncome : listOutcome;

    if (_isSelectedIncome) {
      chartData = provider.getIncomeByTag(selectedOption);
    } else {
      chartData = provider.getOutcomeByTag(selectedOption);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 50),
            IncomeOutcomeToggle(
              onIncomeSelected: () {
                setState(() {
                  _isSelectedIncome = true;
                });
              },
              onOutcomeSelected: () {
                setState(() {
                  _isSelectedIncome = false;
                });
              },
            ),
            IconButton(
              onPressed:
                  () => showExportDialogOptions(context, (
                    SelectedExporter e,
                  ) async {
                    var exporter = ExporterFactory.getExporter(e);
                    var path = await exporter.export(listIncome, listOutcome);
                    return path;
                  }),
              icon: const Icon(Icons.save),
              color: customGreen,
              iconSize: 35,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  }
                },
                items:
                    <String>[
                      'None',
                      'Category',
                      'Payment Method',
                      'Repeat',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ],
          ),
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
              color: const Color.fromARGB(20, 255, 255, 255),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(70, 114, 114, 114),
                width: 1,
              ),
              boxShadow: const [BoxShadow(color: Colors.transparent)],
            ),
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  return createItemList(context, index, chartData, rawList);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
