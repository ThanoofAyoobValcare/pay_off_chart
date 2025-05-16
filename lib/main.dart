import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PayoffChartScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class PayoffChartScreen extends StatelessWidget {
  const PayoffChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Payoff Chart',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFF23272E),
      body: 
      
      const Center(
        child: CustomPayoffChart(),
      ),
    );
  }
}

class CustomPayoffChart extends StatefulWidget {
  const CustomPayoffChart({super.key});

  @override
  State<CustomPayoffChart> createState() => _CustomPayoffChartState();
}

class _CustomPayoffChartState extends State<CustomPayoffChart> {
  // Example payoff data (butterfly spread style)
  List<FlSpot> getPayoffSpots() {
    List<FlSpot> spots = [];
    for (double price = 800; price <= 2000; price += 5) {
      double payoff;
      if (price < 900) {
        payoff = -2000 + (price - 800) * 2;
      } else if (price < 1000) {
        payoff = (price - 900) * 40;
      } else {
        payoff = 4000 - (price - 1000) * 10;
      }
      spots.add(FlSpot(price, payoff));
    }
    return spots;
  }

  // Example probability curve (normal distribution)
  List<FlSpot> getProbabilitySpots() {
    List<FlSpot> spots = [];
    double mean = 950, std = 40;
    for (double price = 800; price <= 1100; price += 5) {
      double y = 3000 * exp(-pow((price - mean) / std, 2) / 2);
      spots.add(FlSpot(price, y));
    }
    return spots;
  }

  late TransformationController _transformationController;
  @override
  void initState() {
    _transformationController = TransformationController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final payoffSpots = getPayoffSpots();
    final probSpots = getProbabilitySpots();

    return SizedBox(
      height: 300,
      child: LineChart(
        transformationConfig: FlTransformationConfig(
          scaleAxis: FlScaleAxis.free,
          minScale: 10.0,
          maxScale: 1000.0,
          panEnabled: true,
          scaleEnabled: true,
          transformationController: _transformationController,
        ),
         
        LineChartData(
          minX: 800,
          maxX: 1100,
          minY: -3000,
          maxY: 4000,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.white24,
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (_) => FlLine(
              color: Colors.white24,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1000,
                getTitlesWidget: (value, meta) => Text(
                  value > 0 ? '+${value ~/ 1000}K' : '${value ~/ 1000}K',
                  style: TextStyle(
                    color: value >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white24),
          ),
          lineBarsData: [
            // Payoff line
            LineChartBarData(
              spots: payoffSpots,
              isCurved: false,
              color: Colors.orange,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                // ignore: deprecated_member_use
                color: Colors.green.withOpacity(0.12),
                cutOffY: 0,
                applyCutOffY: true,
              ),
              aboveBarData: BarAreaData(
                show: true,
                // ignore: deprecated_member_use
                color: Colors.red.withOpacity(0.12),
                cutOffY: 0,
                applyCutOffY: true,
              ),
              dotData: FlDotData(show: false),
            ),
            // Probability curve
            LineChartBarData(
              spots: probSpots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: FlDotData(show: false),
            ),
          ],
          extraLinesData: ExtraLinesData(
            verticalLines: [
              VerticalLine(
                x: 900,
                color: Colors.orange,
                strokeWidth: 2,
                dashArray: [5, 5],
              ),
              VerticalLine(
                x: 1000,
                color: Colors.orange,
                strokeWidth: 2,
                dashArray: [5, 5],
              ),
              VerticalLine(
                x: 950,
                color: Colors.blue,
                strokeWidth: 1,
                dashArray: [2, 2],
              ),
            ],
            horizontalLines: [
              HorizontalLine(
                y: 0,
                color: Colors.white54,
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'Price: ${spot.x.toStringAsFixed(2)}\nP&L: ${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }
}



