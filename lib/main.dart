import 'package:flutter/material.dart';
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
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor:  Colors.white,
      body: Center(
        child: CustomPayoffChart()
      ),
    );
  }
}
