import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game2d/pixel_adventure.dart';
import 'package:game2d/screens/pause_page.dart';

class PauseButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  final BuildContext context;  // Lưu trữ ngữ cảnh

  PauseButton(this.context);

  @override
  FutureOr<void> onLoad() async {
    double screenWidth = game.size[0];
    double screenHeight = game.size[1];
    double xmargin = screenWidth * 0.02; // 2% của chiều rộng màn hình
    double ymargin = screenHeight * 0.02; // 2% của chiều cao màn hình

    double buttonSize = screenWidth * 0.08; // 8% của chiều rộng màn hình

    // Thử tải sprite và xử lý lỗi nếu thất bại
    try {
      sprite = Sprite(game.images.fromCache('HUD/PauseButton.png'));
    } catch (e) {
      print('Không tải được sprite của PauseButton: $e');
      return;
    }

    size = Vector2.all(buttonSize);
    position = Vector2(
      screenWidth - xmargin - buttonSize,
      ymargin,
    );
    priority = 10;

    await super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PausePage()),
    );
  }
}
