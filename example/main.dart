import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartLabeledData.dart';
import 'package:flutter_chartx/components/types.dart';
import 'package:flutter_chartx/widgets/ColumnChart.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Pretendard"),
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          child: ColumnChart(
            markType: ChartMarkType.percent,
            maxValue: 100,
            datas: [
              ChartLabeledData(label: "A", value: 90, color: Colors.deepOrange),
              ChartLabeledData(label: "B", value: 70, color: Colors.orange),
              ChartLabeledData(label: "C", value: 30, color: Colors.red),
              ChartLabeledData(label: "D", value: 70, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
