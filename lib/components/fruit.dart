import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game2d/components/hitbox.dart';
import 'package:game2d/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;
  final int score; // Thêm trường để lưu điểm số cho quả
  Fruit({
    required this.score,
    super.position,
    super.size,
    super.removeOnFinish = true,
    this.fruit = "Apple",
    this.playSounds = true, // Thêm trường playSounds
    this.soundVolume = 1.0, // Thêm trường soundVolume
  });

  final double stepTime = 0.05;
  final hitbox = CustomHitBox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool collected = false;
  bool playSounds; // Trường playSounds
  double soundVolume; // Trường soundVolume

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("Items/Fruits/$fruit.png"),
        SpriteAnimationData.sequenced(
          amount: 17,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      if (playSounds) { // Sử dụng trường playSounds thay vì truy cập từ PixelAdventure
        FlameAudio.play("collect_fruit.wav", volume: soundVolume); // Sử dụng trường soundVolume thay vì truy cập từ PixelAdventure
      }
      // Tăng điểm số khi quả được ăn
      gameRef.score += score;

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("Items/Fruits/Collected.png"),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
