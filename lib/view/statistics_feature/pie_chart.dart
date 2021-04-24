import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/view/statistics_feature/indicator.dart';

class MyPieChart extends StatelessWidget {
  final List<DoneAlarm> doneAlarms;
  final double scannedCount;
  final double notScannedCount;
  final double radius = 50;

  MyPieChart({this.doneAlarms, this.scannedCount, this.notScannedCount});

  @override
  Widget build(BuildContext context) {
    print('scannedCount: $scannedCount');
    print('notScanned: $notScannedCount');
    if (scannedCount == 0 || notScannedCount == 0) {
      print('sleeping');
      sleep(Duration(seconds: 5));
    }
    return Card(
      color: Colors.grey[800],
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: [
                    PieChartSectionData(
                      color: const Color(0xff0293ee),
                      value: scannedCount,
                      title:
                          scannedCount == 0 ? ' ' : '${scannedCount.toInt()}',
                      radius: radius,
                      titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)),
                    ),
                    PieChartSectionData(
                      color: const Color(0xfff8b250),
                      value: notScannedCount,
                      title: notScannedCount == 0
                          ? ' '
                          : '${notScannedCount.toInt()}',
                      radius: radius,
                      titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)),
                    )
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: Color(0xff0293ee),
                text: 'Completed',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color(0xfff8b250),
                text: 'Abandoned',
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }
}
