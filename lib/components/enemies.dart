import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game2d/components/hitbox.dart';
import 'package:game2d/components/player.dart';
import 'package:game2d/pixel_adventure.dart';

enum State { idle, run, hit }

class Enemies extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  final String enemy;
  Enemies({
    super.position,
    super.size,
    this.enemy = "Chicken",
    this.offNeg = 0,
    this.offPos = 0,
    this.playSounds = true, // Thêm trường playSounds
    this.soundVolume = 1.0, // Thêm trường soundVolume
  });

  static const stepTime = 0.05;
  static const tileSize = 16;
  static const runSpeed = 80;
  static const _bounceHeight = 260.0;
  final textureSize = Vector2(32, 34);

  Vector2 velocity = Vector2.zero();
  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStomped = false;
  bool playSounds; // Trường playSounds
  double soundVolume; // Trường soundVolume

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  @override
  FutureOr<void> onLoad() {
    player = game.player;

    add(
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      ),
    );
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStomped) {
      _updateState();
      _movement(dt);
    }

    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 13);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 15)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/$enemy/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(dt) {
    // set velocity to 0;
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double enemyOffset = (scale.x > 0) ? 0 : -width;

    if (playerInRange()) {
      // player in range
      targetDirection =
      (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
      velocity.x = targetDirection * runSpeed;
    }

    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;

    position.x += velocity.x * dt;
  }

  bool playerInRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return player.x + playerOffset >= rangeNeg &&
        player.x + playerOffset <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;

    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (playSounds) { // Sử dụng trường playSounds thay vì truy cập từ PixelAdventure
        FlameAudio.play('bounce.wav', volume: soundVolume); // Sử dụng trường soundVolume thay vì truy cập từ PixelAdventure
      }
      gotStomped = true;
      current = State.hit;
      player.velocity.y = -_bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.collidedwithEnemy();
    }
  }
}
