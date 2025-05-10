import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y, this.percentage, [this.color]);
  final String x;
  final double y;
  final double percentage;
  final Color? color;
}
/* 
Set<Color> usedColors = {}; // Para evitar repetidos
Color getUniqueColor() {
  Color newColor;
  do {
    newColor = Color.fromRGBO(
      Random().nextInt(181),
      Random().nextInt(181),
      Random().nextInt(181),
      1.0,
    );
  } while (usedColors.contains(newColor)); // Evita colores repetidos
  usedColors.add(newColor);
  return newColor;
} */

class GraphPie extends StatelessWidget {
  const GraphPie({
    super.key,
    required this.chartData,
    required this.legend,
    this.shadowWidth = 0,
    this.shadowHeight = 0,
  });

  final List<ChartData> chartData;
  final Legend legend;
  final double shadowWidth;
  final double shadowHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // shadow
          width: shadowWidth,
          height: shadowHeight,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 0.5,
                blurRadius: 10,
                offset: Offset(10, -10),
              ),
            ],
          ),
        ),

        SfCircularChart(
          legend: legend,
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
