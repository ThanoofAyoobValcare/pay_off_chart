import 'package:flutter/material.dart';

import 'package:pay_off_chart/payoffchart.dart';

void main() {
  runApp(const MaterialApp(
    home: Charts(),
    debugShowCheckedModeBanner: false,
  ));
}

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  bool isChartExpanded = false;
  void _toggleFullscreen() {
    setState(() {
      isChartExpanded = !isChartExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Payoff Chart',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          child: isChartExpanded
              ? // Expanded chart mode - rotated and full screen
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.fullscreen_exit, color: Colors.black),
                      onPressed: _toggleFullscreen,
                    ),
                    Expanded(
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 3, // 90 degrees clockwise
                          child: CustomPayoffChart(),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildDropdown('Range', '15%'),
                          SizedBox(width: 16),
                          _buildDropdown('Probability', '2.5D'),
                          Spacer(),
                          GestureDetector(
                            onTap: _toggleFullscreen,
                            child: Icon(
                              isChartExpanded
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: CustomPayoffChart()),
                  ],
                ),
        ),
        bottomNavigationBar: (!isChartExpanded) ? BottomDetailsWidget() : null);
  }
}

Widget _buildDropdown(String label, String value) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      SizedBox(width: 8),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
          ],
        ),
      ),
    ],
  );
}

class BottomDetailsWidget extends StatelessWidget {
  const BottomDetailsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Header
            ShadedContainer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Portfolio',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        '2 POSITIONS ADDED',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text('Total PNL:',
                      style: TextStyle(fontSize: 16, color: Colors.black87)),
                  Text('+301,043,733',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  RoundedIconButton(
                    iconData: Icons.keyboard_arrow_up,
                    onTap: () {
                      // Your code to execute when the button is tapped
                      debugPrint('Arrow button tapped!');
                    },
                  )
                  // SizedBox(height: 4),
                ],
              ),
            ),

            /// 3. Net Premium Credit Card
            ShadedContainer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Net Premium Credit: ',
                              style: TextStyle(fontSize: 16)),
                          Text('-3,025',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Icon(Icons.refresh, size: 16),
                        ],
                      ),
                      Text(
                        '2 STRIKES ORDER ADDED',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 24),
                      RoundedIconButton(
                        iconData: Icons.keyboard_arrow_up,
                        onTap: () {
                          // Your code to execute when the button is tapped
                          debugPrint('Arrow button tapped!');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    super.key,
    required this.iconData,
    this.size = 40,
    this.iconSize = 24,
    this.borderColor,
    this.iconColor,
    this.backgroundColor = Colors.white,
    this.onTap, // Add the callback function parameter
  });

  final IconData iconData;
  final double size;
  final double iconSize;
  final Color? borderColor;
  final Color? iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap; // Define the callback function type

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Wrap the Container with GestureDetector
      onTap: onTap, // Pass the onTap callback
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: borderColor ?? Colors.grey[300]!,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            iconData,
            size: iconSize,
            color: iconColor ?? Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class ShadedContainer extends StatelessWidget {
  final Widget child;

  const ShadedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Or the background color of your container
        borderRadius: BorderRadius.only(
          // Optional: if your container has rounded corners
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withAlpha(25), // Shadow color with some transparency
            spreadRadius: 1, // Controls how much the shadow spreads
            blurRadius: 5, // Controls the softness of the shadow
            offset: Offset(
                0, -3), // Shifts the shadow vertically (-3 moves it upwards)
          ),
        ],
      ),
      child: child,
    );
  }
}
