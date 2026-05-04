import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.75, w, h * 0.25),
      Paint()..color = const Color(0xFF5a8050),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.18, h * 0.4, w * 0.64, h * 0.5),
      Paint()..color = const Color(0xFFd6cfc5),
    );
    final roofPath = Path()
      ..moveTo(w * 0.12, h * 0.42)
      ..lineTo(w * 0.5, h * 0.1)
      ..lineTo(w * 0.88, h * 0.42)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = const Color(0xFF8a8078));
    final window = Paint()..color = const Color(0xFF7da8b8);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.22, h * 0.5, w * 0.15, h * 0.2),
      window,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.42, h * 0.5, w * 0.16, h * 0.2),
      window,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.63, h * 0.5, w * 0.15, h * 0.2),
      window,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.62, w * 0.14, h * 0.28),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFa09080),
    );
    canvas.drawCircle(
      Offset(w * 0.08, h * 0.6),
      28,
      Paint()..color = const Color(0xFF4a7040),
    );
    canvas.drawCircle(
      Offset(w * 0.92, h * 0.62),
      22,
      Paint()..color = const Color(0xFF4a7040),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = AppColors.bluelight,
    );
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, h * 0.5), Offset(w, h * 0.5), road);
    canvas.drawLine(
      Offset(w * 0.5, 0),
      Offset(w * 0.5, h),
      road..strokeWidth = 4,
    );
    canvas.drawLine(
      Offset(0, h * 0.25),
      Offset(w, h * 0.75),
      road..strokeWidth = 3,
    );
    canvas.drawLine(Offset(w * 0.25, 0), Offset(w * 0.25, h), road);
    canvas.drawLine(Offset(w * 0.75, 0), Offset(w * 0.75, h), road);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.3, h * 0.55, w * 0.18, h * 0.3),
      Paint()..color = const Color(0xFFb8d8a8),
    );
    final pin = Paint()..color = AppColors.blue;
    canvas.drawCircle(Offset(w * 0.42, h * 0.52), 16, pin);
    canvas.drawRect(Rect.fromLTWH(w * 0.42 - 5, h * 0.52, 10, 14), pin);
    final icon = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(w * 0.42 - 5, h * 0.46, 10, 8), icon);
    final roofPath = Path()
      ..moveTo(w * 0.42 - 7, h * 0.46)
      ..lineTo(w * 0.42, h * 0.41)
      ..lineTo(w * 0.42 + 7, h * 0.46)
      ..close();
    canvas.drawPath(roofPath, icon);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
