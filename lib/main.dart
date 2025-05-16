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
        title: const Text('Custom Payoff Chart', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFF23272E),
      body: const Center(
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
  late TransformationController _transformationController;
  bool _isPanEnabled = true;
  bool _isScaleEnabled = true;
  double _currentScale = 5.0;
  Offset _currentPosition = Offset.zero;

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
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _currentScale = 1.0;
    _currentPosition = details.focalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_isScaleEnabled) {
      final newScale = _currentScale * details.scale;
      if (newScale >= 1.0 && newScale <= 25.0) {
        _transformationController.value *= Matrix4.diagonal3Values(
          details.scale,
          details.scale,
          1,
        );
        _currentScale = newScale;
      }
    }

    if (_isPanEnabled) {
      final delta = details.focalPoint - _currentPosition;
      _transformationController.value *= Matrix4.translationValues(
        delta.dx,
        delta.dy,
        0,
      );
      _currentPosition = details.focalPoint;
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _currentScale = 1.0;
  }

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

  @override
  Widget build(BuildContext context) {
    final payoffSpots = getPayoffSpots();
    final probSpots = getProbabilitySpots();

    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       const Text('Pan', style: TextStyle(color: Colors.white)),
        //       Switch(
        //         value: _isPanEnabled,
        //         onChanged: (value) {
        //           setState(() {
        //             _isPanEnabled = value;
        //           });
        //         },
        //       ),
        //       const Text('Scale', style: TextStyle(color: Colors.white)),
        //       Switch(
        //         value: _isScaleEnabled,
        //         onChanged: (value) {
        //           setState(() {
        //             _isScaleEnabled = value;
        //           });
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        // Row(
        //   children: [
        //     const Spacer(),
        //     _TransformationButtons(controller: _transformationController),
        //     const SizedBox(width: 16),
        //   ],
        // ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onScaleEnd: _handleScaleEnd,
              child: LineChart(
                transformationConfig: FlTransformationConfig(
                  scaleAxis: FlScaleAxis.horizontal,
                  minScale: 1.0,
                  maxScale: 25.0,
                  panEnabled: _isPanEnabled,
                  scaleEnabled: _isScaleEnabled,
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
                    LineChartBarData(
                      spots: payoffSpots,
                      isCurved: false,
                      color: Colors.orange,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.12),
                        cutOffY: 0,
                        applyCutOffY: true,
                      ),
                      aboveBarData: BarAreaData(
                        show: true,
                        color: Colors.red.withOpacity(0.12),
                        cutOffY: 0,
                        applyCutOffY: true,
                      ),
                      dotData: FlDotData(show: false),
                    ),
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
            ),
          ),
        ),
      ],
    );
  }
}

class _TransformationButtons extends StatelessWidget {
  const _TransformationButtons({
    required this.controller,
  });

  final TransformationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Zoom in',
          child: IconButton(
            icon: const Icon(
              Icons.add,
              size: 16,
              color: Colors.white,
            ),
            onPressed: _transformationZoomIn,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Move left',
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: _transformationMoveLeft,
              ),
            ),
            Tooltip(
              message: 'Reset zoom',
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: _transformationReset,
              ),
            ),
            Tooltip(
              message: 'Move right',
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: _transformationMoveRight,
              ),
            ),
          ],
        ),
        Tooltip(
          message: 'Zoom out',
          child: IconButton(
            icon: const Icon(
              Icons.minimize,
              size: 16,
              color: Colors.white,
            ),
            onPressed: _transformationZoomOut,
          ),
        ),
      ],
    );
  }

  void _transformationReset() {
    controller.value = Matrix4.identity();
  }

  void _transformationZoomIn() {
    controller.value *= Matrix4.diagonal3Values(
      1.1,
      1.1,
      1,
    );
  }

  void _transformationMoveLeft() {
    controller.value *= Matrix4.translationValues(
      20,
      0,
      0,
    );
  }

  void _transformationMoveRight() {
    controller.value *= Matrix4.translationValues(
      -20,
      0,
      0,
    );
  }

  void _transformationZoomOut() {
    controller.value *= Matrix4.diagonal3Values(
      0.9,
      0.9,
      1,
    );
  }
}



