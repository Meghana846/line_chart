import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:untitled/my_button.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: const Text('Flutter Line Chart'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeartRate(csvFilePath: 'assets/value2.csv'),
            SizedBox(height: 30),
            FutureBuilder( // Use FutureBuilder to read data from CSV file asynchronously
              future: _readCSVData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error loading data: ${snapshot.error}');// Display an error message if an error occurred
                  }
                  // If data is loaded, create LineChart
                  List<List<double>>? data = snapshot.data as List<List<double>>?;
                  return data != null
                      ? NewWidget(data: data)
                      : Text('Data is null');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );

  static Future<List<List<double>>> _readCSVData() async {
    final ByteData data = await rootBundle.load('assets/value1.csv'); // Read the CSV file from the assets
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      String.fromCharCodes(Uint8List.view(data.buffer)),
      shouldParseNumbers: true,
    );

    List<List<double>> extractedData = [];// Extract values from the first column (starting from row 2)
    int counter = 1;
    for (var row in rows.skip(1).take(298)) {
      double yValue = double.parse(row[0].toString());
      extractedData.add([counter.toDouble(), yValue]);
      counter++;
    }

    // Print the extracted data
    //print('Extracted Data: $extractedData');
    return extractedData;
  }
}

class NewWidget extends StatelessWidget {
  final List<List<double>> data;
  const NewWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 450,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 500,
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
                  color: const Color(0xff37434d), strokeWidth: 0.8,
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
              spots: data
                  .map((point) => FlSpot(point[0], point[1]))
                  .toList(),
              color: const Color(0xff02d39a),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
