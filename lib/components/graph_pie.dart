import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y, this.percentage, [this.color]);
  final String x;
  final double y;
  final double percentage;
  final Color? color;
}

class GraphPie extends StatelessWidget {
  const GraphPie({super.key, required this.chartData});

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // shadow
          width: 210,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(10, -10),
              ),
            ],
          ),
        ),

        SfCircularChart(
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<ChartData, String>(
              dataSource: chartData,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.percentage,
              dataLabelMapper: (ChartData data, _) {
                if (data.percentage <= 0) {
                  return ''; // No mostrar la etiqueta
                } else {
                  return '\$${data.y.toStringAsFixed(2)}\n ${data.percentage.toStringAsFixed(2)}%'; // Mostrar los datos
                }
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.inside,
              ),
              strokeColor: const Color.fromARGB(172, 255, 255, 255),
              strokeWidth: 2,
            ),
          ],
        ),
      ],
    );
  }
}
