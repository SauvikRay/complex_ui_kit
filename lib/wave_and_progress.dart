import 'dart:math';

import 'package:flutter/material.dart';

const circleProgressColor = Color(0xFFE0F7FA);
const circleBgColor = Color(0xFF00509D);

const progressTextColor = Colors.white;

class ProgressPainter extends CustomPainter {
  final Animation<double> progress;
  final double circleRadius;

  ProgressPainter({
    required this.progress,
    required this.circleRadius,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);

    _drawCircleProgress(canvas);
    _drawProgressText(canvas);
  }

  /// Draws the circular progress background and arc.
  void _drawCircleProgress(Canvas canvas) {
    Paint circlePaint = Paint()
      ..color = circleBgColor
      ..strokeWidth = circleRadius * 0.077
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    Paint shadow = Paint()
      ..color = Colors.black
      ..strokeWidth = circleRadius * 0.077
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 30);

    canvas.drawCircle(
      Offset.zero,
      circleRadius,
      circlePaint,
    );
    canvas.drawCircle(Offset.zero, circleRadius, shadow);

    circlePaint
      ..color = circleProgressColor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: circleRadius),
      -0.5 * pi,
      2 * pi * (progress.value / 100),
      false,
      circlePaint,
    );
  }

  /// Draws the progress text.
  void _drawProgressText(Canvas canvas) {
    final textSpan = TextSpan(
      text: "${(progress.value).toInt()}%",
      style: TextStyle(
        color: progressTextColor,
        fontSize: circleRadius * 0.4,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

const foregroundWaveColor = Color(0xFF00aaff);
const backgroundWaveColor = Color(0xFF0073E6);

class WavePainter extends CustomPainter {
  final Animation<double> progress;
  final Animation<double> waveAnimation;
  final double circleRadius;

  WavePainter({
    required this.progress,
    required this.waveAnimation,
    required this.circleRadius,
  }) : super(repaint: Listenable.merge([progress, waveAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    _drawWaves(canvas);
  }

  /// Draws the wave fill inside the clipped circle area.
  void _drawWaves(Canvas canvas) {
    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset.zero,
            radius: circleRadius,
          ),
        ),
    );

    /// Draw the background wave first
    _drawSineWave(canvas, backgroundWaveColor);

    /// Draw the foreground wave with shifting and mirror it for more realistic waves effect
    _drawSineWave(canvas, foregroundWaveColor, mirror: true, shift: circleRadius / 2);
  }

  /// Draws a single sine wave inside the clipped area.
  /// sine wave explanation -> https://mathematicalmysteries.org/sine-wave/
  void _drawSineWave(Canvas canvas, Color waveColor, {double shift = 0.0, bool mirror = false}) {
    if (mirror) {
      canvas.save();
      canvas.transform(Matrix4.rotationY(pi).storage);
    }

    double startX = -circleRadius;
    double endX = circleRadius;
    double startY = circleRadius;
    double endY = -circleRadius;

    double amplitude = circleRadius * 0.15;
    double angularVelocity = pi / circleRadius;
    double delta = Curves.slowMiddle.transform(progress.value / 100);

    double offsetX = 2 * circleRadius * waveAnimation.value + shift;
    double offsetY = startY + (endY - startY - amplitude) * delta;

    Paint wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..isAntiAlias = true;

    Path path = Path();

    for (double x = startX; x <= endX; x++) {
      /// y = A * sin(ωx + φ) wave function itself, where A is amplitude, ω is angular velocity, φ is phase shift(x)
      double y = amplitude * sin(angularVelocity * (x + offsetX));
      if (x == startX) {
        path.moveTo(x, y + offsetY);
      } else {
        path.lineTo(x, y + offsetY);
      }
    }

    path.lineTo(endX, startY);
    path.lineTo(startX, startY);
    path.close();

    canvas.drawPath(path, wavePaint);
    if (mirror) canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
