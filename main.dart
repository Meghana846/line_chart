import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'my_button.dart';

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
            HeartRate(), // Use the first widget
            SizedBox(height: 30), // Add some spacing
            FutureBuilder(
              // Use FutureBuilder to read data from CSV file asynchronously
              future: _readCSVData('path/to/your/csv/file.csv'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // Display an error message if an error occurred
                    return Text('Error loading data: ${snapshot.error}');
                  }
                  // If data is loaded, create LineChart
                  List<List<double>>? data =
                  snapshot.data as List<List<double>>?;
                  return data != null
                      ? NewWidget(data: data)
                      : Text('Data is null');
                } else {
                  // Display a loading indicator while data is being loaded
                  return CircularProgressIndicator();
                }
              },
            ), // Use the second widget
          ],
        ),
      ),
    ),
  );

  static Future<List<List<double>>> _readCSVData(String filePath) async {

    final File file = File('assests/output.csv');
    List<List<double>> data = [];

    // Read the CSV file
    String contents = await file.readAsString();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
        .convert(contents, shouldParseNumbers: true);

    // Use a counter for incrementing x-values
    int counter = 1;

    for (var row in rowsAsListOfValues.take(100)) {
      double yValue = double.parse(row[0].toString()); // y-values are in the first column
      data.add([counter.toDouble(), yValue]);
      counter++;
    }

    // Print the extracted data
    print('Extracted Data: $data');
    return data;
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
                  color: const Color(0xff37434d), strokeWidth: 0.8);
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
                //isCurved: true,
                color: const Color(0xff02d39a),
                barWidth: 3,
                //dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                )),
          ],
        ),
      ),
    );
  }
}
