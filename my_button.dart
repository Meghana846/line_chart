// heart_rate.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class HeartRate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, width: 450,
    child : LineChart(
      LineChartData(
        minX: 0,
        maxX: 300,
        minY: 0,
        maxY: 300,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 0.8
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
              spots: [
                FlSpot(0, 36),
                FlSpot(36, 47),
                FlSpot(47, 62),
                FlSpot(62, 70),
                FlSpot(70, 80),
                FlSpot(80, 56),
                FlSpot(95, 120),
                FlSpot(140, 60),
                FlSpot(200, 200),
                FlSpot(240, 60),
                FlSpot(280, 40),
                FlSpot(285, 20),
                FlSpot(295, 10),
                FlSpot(300, 0),
              ],
              //isCurved: true,
              color: const Color(0xff02d39a),
              barWidth: 3,
              //dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
              )
          ),
        ],
      ),
    ),
    );
  }
}
