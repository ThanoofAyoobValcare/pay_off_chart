import 'dart:math';
import 'package:flutter/material.dart';

class CustomPayoffChart extends StatefulWidget {
  @override
  _CustomPayoffChartState createState() => _CustomPayoffChartState();
}

class _CustomPayoffChartState extends State<CustomPayoffChart> {
  Offset? touchPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        setState(() {
          touchPosition = details.localPosition;
        });
      },
      onPanEnd: (_) {
        setState(() {
          touchPosition = null;
        });
      },
      child: CustomPaint(
        size: Size(double.infinity, 400),
        painter: PayoffChartPainter(touchPosition: touchPosition),
      ),
    );
  }
}

class PayoffChartPainter extends CustomPainter {
  final Offset? touchPosition;
  PayoffChartPainter({this.touchPosition});

  // Example data
  final double minX = 800, maxX = 1100, minY = -3000, maxY = 4000;
  final List<double> payoffData = List.generate(301, (i) {
    int x = 800 + i;
    // Example: simple call spread payoff
    if (x < 900) return -2000 + (x - 800) * 2;
    if (x < 1000) return (x - 900) * 40;
    return 4000 - (x - 1000) * 10;
  });
  final List<double> probabilityData = List.generate(301, (i) {
    int x = 800 + i;
    // Example: normal distribution centered at 950
    double mean = 950, std = 40;
    return 3000 * exp(-pow((x - mean) / std, 2) / 2);
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintAxis = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    final paintPayoff = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2;
    final paintProb = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    final paintProfit = Paint()
      ..color = Colors.green.withOpacity(0.1);
    final paintLoss = Paint()
      ..color = Colors.red.withOpacity(0.1);

    // Chart area
    final chartRect = Rect.fromLTWH(50, 20, size.width - 70, size.height - 60);

    // Draw axes
    canvas.drawLine(
        Offset(chartRect.left, chartRect.bottom),
        Offset(chartRect.right, chartRect.bottom),
        paintAxis);
    canvas.drawLine(
        Offset(chartRect.left, chartRect.top),
        Offset(chartRect.left, chartRect.bottom),
        paintAxis);

    // Draw grid and labels
    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    for (int i = 0; i <= 5; i++) {
      double y = chartRect.bottom - i * chartRect.height / 5;
      double value = minY + (maxY - minY) * i / 5;
      canvas.drawLine(
          Offset(chartRect.left, y), Offset(chartRect.right, y), paintAxis..color = Colors.grey.withOpacity(0.2));
      textPainter.text = TextSpan(
          text: value.toInt().toString(),
          style: TextStyle(color: Colors.grey, fontSize: 12));
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 8));
    }
    for (int i = 0; i <= 6; i++) {
      double x = chartRect.left + i * chartRect.width / 6;
      double value = minX + (maxX - minX) * i / 6;
      canvas.drawLine(
          Offset(x, chartRect.top), Offset(x, chartRect.bottom), paintAxis..color = Colors.grey.withOpacity(0.2));
      textPainter.text = TextSpan(
          text: value.toInt().toString(),
          style: TextStyle(color: Colors.grey, fontSize: 12));
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - 15, chartRect.bottom + 5));
    }

    // Helper to map data to chart coordinates
    double mapX(int i) => chartRect.left + (i / (payoffData.length - 1)) * chartRect.width;
    double mapY(double y) => chartRect.bottom - ((y - minY) / (maxY - minY)) * chartRect.height;

    // Draw profit/loss areas
    Path profitPath = Path(), lossPath = Path();
    profitPath.moveTo(mapX(0), mapY(0));
    lossPath.moveTo(mapX(0), mapY(0));
    for (int i = 0; i < payoffData.length; i++) {
      double x = mapX(i), y = mapY(payoffData[i]);
      if (payoffData[i] >= 0) {
        profitPath.lineTo(x, y);
      } else {
        lossPath.lineTo(x, y);
      }
    }
    profitPath.lineTo(mapX(payoffData.length - 1), mapY(0));
    profitPath.close();
    lossPath.lineTo(mapX(payoffData.length - 1), mapY(0));
    lossPath.close();
    canvas.drawPath(profitPath, paintProfit);
    canvas.drawPath(lossPath, paintLoss);

    // Draw payoff line
    Path payoffPath = Path();
    for (int i = 0; i < payoffData.length; i++) {
      double x = mapX(i), y = mapY(payoffData[i]);
      if (i == 0) {
        payoffPath.moveTo(x, y);
      } else {
        payoffPath.lineTo(x, y);
      }
    }
    canvas.drawPath(payoffPath, paintPayoff);

    // Draw probability curve
    Path probPath = Path();
    for (int i = 0; i < probabilityData.length; i++) {
      double x = mapX(i), y = mapY(probabilityData[i]);
      if (i == 0) {
        probPath.moveTo(x, y);
      } else {
        probPath.lineTo(x, y);
      }
    }
    canvas.drawPath(probPath, paintProb);

    // Draw tooltip if touched
    if (touchPosition != null &&
        chartRect.contains(touchPosition!)) {
      double relX = (touchPosition!.dx - chartRect.left) / chartRect.width;
      int idx = (relX * (payoffData.length - 1)).clamp(0, payoffData.length - 1).toInt();
      double px = mapX(idx), py = mapY(payoffData[idx]);
      canvas.drawCircle(Offset(px, py), 5, Paint()..color = Colors.black);
      // Tooltip box
      textPainter.text = TextSpan(
          text: 'Price: ${(minX + (maxX - minX) * idx / (payoffData.length - 1)).toStringAsFixed(2)}\nP&L: ${payoffData[idx].toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white, fontSize: 12));
      textPainter.layout();
      Rect tooltipRect = Rect.fromLTWH(px + 10, py - 30, textPainter.width + 10, textPainter.height + 10);
      canvas.drawRect(tooltipRect, Paint()..color = Colors.black.withOpacity(0.7));
      textPainter.paint(canvas, Offset(px + 15, py - 25));
    }
  }

  @override
  bool shouldRepaint(covariant PayoffChartPainter oldDelegate) =>
      oldDelegate.touchPosition != touchPosition;
}