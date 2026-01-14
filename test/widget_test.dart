import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame_tetris/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SimpleGame', () {
    // ignore: discarded_futures, testWithGame registers tests synchronously
    testWithGame<SimpleGame>(
      'loads player on game start',
      SimpleGame.new,
      (game) async {
        await game.ready();

        expect(game.children.whereType<Player>().length, equals(1));
      },
    );

    // ignore: discarded_futures, testWithGame registers tests synchronously
    testWithGame<SimpleGame>(
      'player is centered on load',
      SimpleGame.new,
      (game) async {
        await game.ready();

        final player = game.children.whereType<Player>().first;
        expect(player.position, equals(game.size / 2));
      },
    );
  });

  group('Player', () {
    test('moves 20 pixels to the right when move is called', () {
      final player = Player();
      final initialX = player.position.x;

      player.move();

      expect(player.position.x, equals(initialX + 20));
    });

    test('has correct initial size', () {
      final player = Player();

      expect(player.size.x, equals(50));
      expect(player.size.y, equals(50));
    });
  });

  group('Golden tests', () {
    testGolden(
      'SimpleGame renders correctly',
      (game, tester) async {
        // SimpleGame is passed via game parameter, already set up
      },
      goldenFile: 'goldens/simple_game.png',
      size: Vector2(800, 600),
      game: SimpleGame(),
    );

    testGolden(
      'Player renders as blue square',
      (game, tester) async {
        game.add(
          Player()
            ..position = Vector2(100, 100)
            ..anchor = Anchor.center,
        );
      },
      goldenFile: 'goldens/player.png',
      size: Vector2(200, 200),
      backgroundColor: Colors.white,
    );
  });
}
