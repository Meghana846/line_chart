import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled/lead1.dart';
import 'package:untitled/lead2.dart';
import 'package:untitled/lead3.dart';
import 'package:untitled/v1.dart';
import 'package:untitled/v2.dart';
import 'package:untitled/v3.dart';
import 'package:untitled/v4.dart';
import 'package:untitled/v5.dart';
import 'package:untitled/v6.dart';
import 'package:untitled/avl.dart';
import 'package:untitled/avr.dart';
import 'package:untitled/avf.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: const Text('Flutter Line Chart'),
            ),
          ),
          body: Container(
            width: MediaQuery.sizeOf(context).width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16),

                  //SizedBox(height: 10),
                  Row(
                    children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width,
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: MediaQuery.sizeOf(context).width * 0.32,
                          height: 300,
                          child: Lead1(csvFilePath: 'assets/Lead1.csv'),
                        ),
                        SizedBox(width: MediaQuery.sizeOf(context).width * 0.32,
                          height: 300,
                          child: Lead2(csvFilePath: 'assets/Lead2.csv'),
                        ),
                        SizedBox(width: MediaQuery.sizeOf(context).width * 0.32,
                          height: 300,
                          child: Lead3(csvFilePath: 'assets/Lead3.csv'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                  SizedBox(height: 40),

                  //SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.sizeOf(context).width,
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: v1(csvFilePath: 'assets/V1.csv'),
                            ),
                            SizedBox(width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: V2(csvFilePath: 'assets/V2.csv'),
                            ),
                            SizedBox(width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: v3(csvFilePath: 'assets/V3.csv'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.sizeOf(context).width,
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: v4(csvFilePath: 'assets/V4.csv'),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: v5(csvFilePath: 'assets/V5.csv'),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: v6(csvFilePath: 'assets/V6.csv'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  Row(
                    children: [
                      SizedBox(width: MediaQuery.sizeOf(context).width,
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: avf(csvFilePath: 'assets/avf.csv'),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: avl(csvFilePath: 'assets/avl.csv'),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.32,
                              height: 300,
                              child: avr(csvFilePath: 'assets/avr.csv'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
}
