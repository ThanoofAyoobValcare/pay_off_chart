import 'package:flutter/material.dart';
import 'package:pay_off_chart/barchart.dart';
import 'package:pay_off_chart/payoffchart.dart';

void main() {
  runApp(const MaterialApp(
    home: Charts(),
    debugShowCheckedModeBanner: false,
  ));
}

class Charts extends StatelessWidget {
  const Charts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Payoff Chart',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
      backgroundColor:  Colors.black,
      body: Center(
        child: CustomPayoffChart()
      ),
    );
  }
}
