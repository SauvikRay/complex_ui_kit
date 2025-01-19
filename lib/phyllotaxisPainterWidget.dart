import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';

class PhyllotaxisPainterWidget extends StatefulWidget {
  const PhyllotaxisPainterWidget({super.key});

  @override
  _PhyllotaxisPainterWidgetState createState() => _PhyllotaxisPainterWidgetState();
}

class _PhyllotaxisPainterWidgetState extends State<PhyllotaxisPainterWidget> with SingleTickerProviderStateMixin {
  int counter = 0; // Counter equivalent to `self.counter1` in Kivy
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Schedule periodic updates
    // timer = Timer.periodic(const Duration(milliseconds: 11), (timer) {
    //   setState(() {
    //     counter++;
    //   });
    // });
    // timer = Timer.periodic(Durations.extralong4, (_) {
    //   setState(() {
    //     counter++;
    //   });
    // });
  }

  void startIncrementing() {
    timer = Timer.periodic(const Duration(milliseconds: 3), (timer) {
      setState(() {
        counter++; // Increase the value
      });
    });
  }

  void stopIncrementing() {
    timer.cancel(); // Stop the timer
  }

  @override
  void dispose() {
    stopIncrementing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Phyllotaxis Painter"),
      ),
      body: GestureDetector(
        onTapDown: (_) {
          startIncrementing(); // Start increasing the value on tap down
        },
        onTapUp: (_) {
          stopIncrementing(); // Stop increasing the value on tap release
        },
        onTapCancel: () {
          stopIncrementing(); // Stop increasing the value if the tap is canceled
        },
        child: CustomPaint(
          painter: PhyllotaxisPainter(counter),
          size: MediaQuery.of(context).size, // Fullscreen canvas
        ),
      ),
    );
  }
}

class PhyllotaxisPainter extends CustomPainter {
  final int counter;
  PhyllotaxisPainter(this.counter);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    const double c = 6.0; // Constant for scaling the radius

    for (int n = 0; n < counter; n++) {
      double angle = n * 137.5 * (pi / 180); // Convert degrees to radians
      double r = c * sqrt(n);
      double x = r * cos(angle) + centerX;
      double y = r * sin(angle) + centerY;

      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        double hue = (angle - r) % 1.0; // HSV hue
        Paint paint = Paint()..color = HSVColor.fromAHSV(1.0, hue * 360, 1.0, 1.0).toColor();

        double circleSize = (n % 5).toDouble();
        canvas.drawCircle(Offset(x, y), circleSize, paint);
        canvas.drawCircle(Offset(-x, y), circleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on every frame
  }
}
