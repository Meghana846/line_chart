import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class v1 extends StatelessWidget { 
  final String csvFilePath;
  v1({required this.csvFilePath});

  Future<List<List<double>>> _readCSVData() async {
    // Read the CSV file from the assets
    final ByteData data = await rootBundle.load(csvFilePath);
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      String.fromCharCodes(Uint8List.view(data.buffer)),
      shouldParseNumbers: true,
    );

    // Extract values from the first column (starting from row 2)
    List<List<double>> extractedData = [];
    int counter = 1;
    for (var row in rows.skip(1).take(498)) {
      double yValue = double.parse(row[0].toString());
      extractedData.add([counter.toDouble(), yValue]);
      counter++;
    }

    //print('Extracted Data of graph heart rate: $extractedData');
    return extractedData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder( // Use FutureBuilder to read data from CSV file asynchronously
      future: _readCSVData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Display an error message if an error occurred
            return Text('Error loading data: ${snapshot.error}');
          }
          // If data is loaded, create LineChart
          List<List<double>>? data = snapshot.data as List<List<double>>?;
          return data != null
              ? _buildChart(data)
              : Text('Data is null');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildChart(List<List<double>> data) {
    return SizedBox(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 500, // Adjust the max value as needed
          minY: 0,
          maxY: 10,
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
                strokeWidth: 0.8,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 3),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .map((point) => FlSpot(point[0], point[1]))
                  .toList(),
              color: const Color(0xff02d39a),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
              ),
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
