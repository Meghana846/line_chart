import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/services.dart' show ByteData, rootBundle;

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
          child: const Text('Flutter CSV Reader'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              // Use FutureBuilder to read data from CSV file asynchronously
              future: _readCSVData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // Display an error message if an error occurred
                    return Text('Error loading data: ${snapshot.error}');
                  }
                  // If data is loaded, display the values of the first column
                  List<double> data = snapshot.data as List<double>;
                  return Column(
                    children: data
                        .map((value) => Text(value.toString()))
                        .toList(),
                  );
                } else {
                  // Display a loading indicator while data is being loaded
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );

  static Future<List<double>> _readCSVData() async {
    // Read the CSV file from the assets
    final ByteData data = await rootBundle.load('assets/output1.csv');
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      String.fromCharCodes(Uint8List.view(data.buffer)),
      shouldParseNumbers: true,
    );

    // Extract values from the first column
    List<double> columnValues = [];
    for (var row in rows) {
      if (row.isNotEmpty) {
        try {
          double value = double.parse(row[0].toString());
          columnValues.add(value);
        } catch (e) {
          print('Error parsing value: ${row[0]}');
        }
      }
    }

    // Print the extracted data
    print('Extracted Data: $columnValues');
    return columnValues;
  }
}
