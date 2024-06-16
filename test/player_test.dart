import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game2d/components/checkpoint.dart';
import 'package:game2d/components/enemies.dart';
import 'package:game2d/components/fruit.dart';
import 'package:game2d/components/player.dart';
import 'package:game2d/components/saw.dart';
import 'package:game2d/sound_provider.dart';
import 'package:mockito/mockito.dart';

// Mock class for SoundProvider
class MockSoundProvider extends Mock implements SoundProvider {}

// Mock classes for game entities
class MockFruit extends Mock implements Fruit {
  void collidedWithPlayer() {}
}

class MockSaw extends Mock implements Saw {
  void collidedWithPlayer() {}
}

class MockEnemies extends Mock implements Enemies {
  void collidedWithPlayer() {}
}

class MockCheckpoint extends Mock implements Checkpoint {
  void reachedCheckpoint() {}
}

void main() {
  group('Player Tests', () {
    late Player player;
    late MockSoundProvider mockSoundProvider;

    setUp(() {
      mockSoundProvider = MockSoundProvider();
      player = Player(
        position: Vector2.zero(),
        character: 'default_character',
        soundProvider: mockSoundProvider,
      );
    });

    test('Player initialization', () {
      expect(player.position, Vector2.zero());
      expect(player.character, 'default_character');
      expect(player.current, PlayerState.idle);
      expect(player.velocity, Vector2.zero());
      expect(player.isOnGround, false);
      expect(player.hasJumped, false);
      expect(player.gotHit, false);
      expect(player.reachedCheckpoint, false);
    });

    test('Player jump', () {
      player.hasJumped = true;
      player.isOnGround = true;

      player.update(0.1); // Simulate update

      expect(player.velocity.y, lessThan(0)); // Player should jump upwards
      expect(player.isOnGround, false); // Player should not be on ground after jumping
    });

    test('Player collision handling', () {
      // Mock collision objects
      var mockFruit = MockFruit();
      var mockSaw = MockSaw();
      var mockEnemies = MockEnemies();
      var mockCheckpoint = MockCheckpoint();

      // Trigger collision events
      player.onCollisionStart({}, mockFruit);
      player.onCollisionStart({}, mockSaw);
      player.onCollisionStart({}, mockEnemies);
      player.onCollisionStart({}, mockCheckpoint);

      // Verify interactions
      verify(mockFruit.collidedWithPlayer()).called(1);
      verify(mockSaw.collidedWithPlayer()).called(1);
      verify(mockEnemies.collidedWithPlayer()).called(1);
      verify(mockCheckpoint.reachedCheckpoint()).called(1);
    });

    tearDown(() {
      // Clean up if needed
    });
  });
}
