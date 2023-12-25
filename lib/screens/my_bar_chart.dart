import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyCustomChart extends StatefulWidget {
  const MyCustomChart({super.key});

  @override
  State<MyCustomChart> createState() => _MyCustomChartState();
}

class _MyCustomChartState extends State<MyCustomChart> {
  final List<Map<String, dynamic>> chartData = [
    {
      "id": 40,
      "price": 255.0,
      "date": "2023-12-15T07:26:48.303668+05:30",
      "product": 3
    },
    {
      "id": 37,
      "price": 1000.0,
      "date": "2023-12-16T03:00:01.290428+05:30",
      "product": 3
    },
    {
      "id": 36,
      "price": 1.0,
      "date": "2023-12-17T02:59:47.501567+05:30",
      "product": 3
    },
    {
      "id": 35,
      "price": 10.0,
      "date": "2023-12-18T02:57:06.107673+05:30",
      "product": 3
    },
    {
      "id": 34,
      "price": 60.0,
      "date": "2023-12-19T02:56:37.605855+05:30",
      "product": 3
    },
    {
      "id": 33,
      "price": 70.0,
      "date": "2023-12-20T02:56:28.140412+05:30",
      "product": 3
    },
    {
      "id": 32,
      "price": 60.0,
      "date": "2023-12-21T02:54:29.631312+05:30",
      "product": 3
    },
    {
      "id": 31,
      "price": 50.0,
      "date": "2023-12-22T02:50:28.901549+05:30",
      "product": 3
    },
    {
      "id": 30,
      "price": 20.0,
      "date": "2023-12-23T02:50:05.647075+05:30",
      "product": 3
    },
    {
      "id": 29,
      "price": 10.0,
      "date": "2023-12-24T02:49:53.963694+05:30",
      "product": 3
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart View"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 0.01.sh,
          ),
          SizedBox(
            height: 0.5.sh,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(isVisible: true),
              primaryYAxis: NumericAxis(),
              series: <ChartSeries>[
                LineSeries<Map<String, dynamic>, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (Map<String, dynamic> entry, _) =>
                      DateTime.parse(entry['date']),
                  yValueMapper: (Map<String, dynamic> entry, _) =>
                      entry['price'],
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.day, this.price);
  final DateTime day;
  final double price;
}
