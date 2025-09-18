import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class VerticalStep extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isActive;

  VerticalStep({
    required this.title,
    required this.subtitle,
    this.isActive = false,
  });

  @override
  _VerticalStepState createState() => _VerticalStepState();
}

class _VerticalStepState extends State<VerticalStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPaint(
              size: Size(24.0, 24.0),
              painter: DotPainter(
                isActive: widget.isActive,
                animation: _animation,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: widget.isActive ? Colors.black : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.isActive) Divider(), // Add a divider if the step is active
      ],
    );
  }
}

class DotPainter extends CustomPainter {
  final bool isActive;
  final Animation<double> animation;

  DotPainter({required this.isActive, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = RadialGradient(
      colors: [
        Color(0xFFF7D9E3),
        Color(0xFFCBD4F4),
      ],
    );
    final paint = Paint()..shader = gradient.createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
    final radius = size.width / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scaledRadius = radius * animation.value;
    canvas.drawCircle(Offset(centerX, centerY), scaledRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}