import 'package:flutter/material.dart';
import 'package:flame/components.dart'; // Đảm bảo import này đúng cho Flame
import 'package:game2d/score_display.dart'; // Điều chỉnh đường dẫn tùy theo cấu trúc dự án của bạn

// PositionComponentWidget để bao bọc ScoreDisplay
class ScoreDisplayWidget extends StatelessWidget {
  final ScoreDisplay scoreDisplay;

  ScoreDisplayWidget({required this.scoreDisplay});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // Thực hiện logic CustomPaint của riêng bạn dựa trên Flame
      painter: FlameScorePainter(scoreDisplay), // Ví dụ về CustomPainter
    );
  }
}

// CustomPainter implementation for ScoreDisplay rendering
class FlameScorePainter extends CustomPainter {
  final ScoreDisplay scoreDisplay;

  FlameScorePainter(this.scoreDisplay);

  @override
  void paint(Canvas canvas, Size size) {
    // Thực hiện logic vẽ dựa trên Flame
    scoreDisplay.render(canvas); // Sử dụng phương thức render của Flame
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Đơn giản là luôn vẽ lại trong ví dụ này
  }
}
