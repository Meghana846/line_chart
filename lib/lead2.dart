import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class Lead2 extends StatefulWidget {
  final String csvFilePath;
  Lead2({required this.csvFilePath});

  @override
  _Lead2State createState() => _Lead2State();
}

class _Lead2State extends State<Lead2> {
  late bool _shouldRepeatAnimation;
  late bool _isPageLoaded;

  @override
  void initState() {
    super.initState();
    _shouldRepeatAnimation = true;
    _isPageLoaded = false;
  }

  Future<List<List<double>>> _readCSVData() async {
    // Read the CSV file from the assets
    final ByteData data = await rootBundle.load(widget.csvFilePath);
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
    // Set the flag to true when the data is loaded for the first time
    if (!_isPageLoaded) {
      _isPageLoaded = true;
    }
    //print('Extracted Data of graph heart rate: $extractedData');
    return extractedData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Use FutureBuilder to read data from CSV file asynchronously
      future: _readCSVData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error loading data: ${snapshot.error}');
          }

          if (_isPageLoaded) {
            List<List<double>>? data = snapshot.data as List<List<double>>?;
            return data != null
                ? _buildAnimatedChart(data)
                : Text('Data is null');
          } else {
            // Return an empty container or placeholder while waiting for data
            return Container();
          }
        } else {
          // Return an empty container or placeholder while waiting for data
          return Container();
        }
      },
    );
  }

  Widget _buildAnimatedChart(List<List<double>> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      Text('Lead2', // Replace with your desired title
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(
      height: 260,
      width: 700,
      child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: data.length.toDouble()),
          duration: const Duration(seconds: 5), // Adjust the duration as needed
          builder: (context, value, child) {
            final int endIndex = value.toInt().clamp(0, data.length);
            final List<List<double>> animatedData = data.sublist(0, endIndex);
            return LineChart(
              LineChartData(
                minX: 0,
                maxX: 500, // Adjust the max value as needed
                minY: -2,
                maxY: 2,
                gridData: FlGridData(
                  show: false,
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
                    spots: animatedData
                        .map((point) => FlSpot(point[0], point[1]))
                        .toList(),
                    color: const Color(0xff02d39a),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (index == animatedData.length - 1) {
                          return FlDotCirclePainter(
                            color: Colors.red,
                            radius: 4.0,
                            strokeWidth: 5,
                            strokeColor: Colors.black12,
                          );
                        } else {
                          // Return a transparent dot for other points
                          return FlDotCirclePainter(
                            color: Colors.transparent,
                            radius: 0,
                            strokeWidth: 0,
                            strokeColor: Colors.transparent,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          onEnd: () {
            if (_shouldRepeatAnimation) {
              setState((){
                _shouldRepeatAnimation = true;
              });
            }
          }
      ),
    ),
    ],
    );
  }
}
