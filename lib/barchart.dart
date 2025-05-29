import 'package:flutter/material.dart';
import 'package:pay_off_chart/package/flip_charts.dart';

class OptionOIBarChart extends StatefulWidget {
  final List<double> strikes;
  final List<double> callOI;
  final List<double> putOI;
  final double futurePrice;

  const OptionOIBarChart({
    super.key,
    required this.strikes,
    required this.callOI,
    required this.putOI,
    required this.futurePrice,
  });

  @override
  State<OptionOIBarChart> createState() => _OptionOIBarChartState();
}

class _OptionOIBarChartState extends State<OptionOIBarChart> {
  late TransformationController _transformationController;

  @override
  void initState() {
    _transformationController = TransformationController();
    _transformationZoomIn();
    super.initState();
  }

  void _transformationZoomIn() {
    _transformationController.value *= Matrix4.diagonal3Values(
      1.1,
      1.1,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BarChart(
              transformationConfig: FlTransformationConfig(
                scaleAxis: FlScaleAxis.horizontal,
                minScale: 1.0,
                maxScale: 25.0,
                panEnabled: true,
                scaleEnabled: true,
                transformationController: _transformationController,
              ),
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: 13000,
                minY: -13000,
                groupsSpace: 8,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final strike = widget.strikes[group.x.toInt()];
                      return BarTooltipItem(
                        'Total OI (Lots)\n'
                        'Strike: ${strike.toStringAsFixed(0)}\n',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '● ',
                            style: TextStyle(
                              color: rodIndex == 0 ? Colors.green : Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: rodIndex == 0
                                ? 'Call OI: ${widget.callOI[group.x.toInt()].toStringAsFixed(0)}\n'
                                : 'Put OI: ${widget.putOI[group.x.toInt()].toStringAsFixed(0)}\n',
                            style: TextStyle(
                              color: rodIndex == 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        );
                      },
                      // getTitlesWidget: (value, meta) => Text(
                      //   value.toInt().toString(),
                      //   style: const TextStyle(color: Colors.black),
                      // ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        // if (idx < 0 || idx >= widget.strikes.length) {
                        //   return SizedBox();
                        // }
                        return RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            widget.strikes[idx].toStringAsFixed(0),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: List.generate(widget.strikes.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: widget.callOI[i],
                        color: Colors.green,
                        width: 10,
                        borderRadius: BorderRadius.zero,
                      ),
                      BarChartRodData(
                        toY: widget.putOI[i],
                        color: Colors.red,
                        width: 10,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                    // showingTooltipIndicators: [0, ],
                  );
                }),
                gridData: FlGridData(
                  show: false,
                  // drawHorizontalLine: true,
                  // drawVerticalLine: true,
                  // verticalInterval: 1000,
                  // horizontalInterval: 1000,
                  // getDrawingHorizontalLine: (value) => FlLine(
                  //   color: Colors.black12,
                  //   strokeWidth: 1,
                  // ),
                  // getDrawingVerticalLine: (value) => FlLine(
                  //   color: Colors.black12,
                  //   strokeWidth: 2,
                  // ),
                ),
                borderData: FlBorderData(show: false),
                // rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: [
                //   VerticalRangeAnnotation(
                //       color: Colors.red, x1: 1875, x2: 1850 + 0.5)
                // ]),
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: 1952.75, // Replace with the actual future price data point
                      color: Colors
                          .blue, // Or another color that matches your design
                      strokeWidth: 1.5,
                      dashArray: [8, 4], // Example dash pattern
                      // label: Label(
                      //   show: true,
                      //   text: 'FUTURE PRICE: 1,952.75', // Replace with actual data
                      //   style: TextStyle(
                      //     color: Colors.blue, // Or another color
                      //     fontSize: 11,
                      //   ),
                      //   // You might need to adjust alignment or padding here
                      //   // depending on your desired label positioning relative to the line.
                      //   // The default vertical label drawing should place it at the top.
                      // ),
                    ),
                  ],
                ),
                
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Example usage with dummy data
class OptionOIBarChartDemo extends StatelessWidget {
  const OptionOIBarChartDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> strikes = [
      1800,
      1825,
      1850,
      1875,
      1900,
      1925,
      1950,
      1975,
      2000,
      2025,
      2050,
      2075
    ];
    final List<double> callOI = [
      9000,
      -7000,
      6000,
      8000,
      4000,
      12000,
      11000,
      6000,
      4000,
      3000,
      2000,
      1000
    ];
    final List<double> putOI = [
      -2000,
      -2000,
      3000,
      4000,
      5000,
      6000,
      7000,
      8000,
      9000,
      10000,
      11000,
      12000
    ];
    final double futurePrice = 1952.75;
    return Center(
      child: OptionOIBarChart(
        strikes: strikes,
        callOI: callOI,
        putOI: putOI,
        futurePrice: futurePrice,
      ),
    );
  }
}
