import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Color> colors;
  final List<String> xLabels;
  final List<List<double>> data;

  const Chart({
    Key? key,
    required this.colors,
    required this.xLabels,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: false,
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 1 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              color: const Color(0xffe7e8ec),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) =>
                  const TextStyle(color: Color(0xff939393), fontSize: 10),
              margin: 10,
              getTitles: (double value) => xLabels[value.toInt()],
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                  color: Color(
                    0xff939393,
                  ),
                  fontSize: 10),
              margin: 0,
            ),
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: getData(constrains.maxWidth),
        ),
      );
    });
  }

  List<BarChartGroupData> getData(double width) {
    return List.generate(data.length, (i) {
      final item = data[i];
      final sum = item.fold<double>(0.0, (acc, v) => acc + v);
      double next = 0.0;
      return BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          y: sum,
          rodStackItems: List.generate(item.length, (index) {
            final prev = next;
            next = item[index] + prev;
            return BarChartRodStackItem(prev, next, colors[index]);
          }),
          width: (width * .6) / data.length,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        )
      ]);
    });
  }
}
