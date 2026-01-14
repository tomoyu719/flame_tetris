import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SimpleGame()));
}

/// A simple Flame game demo.
class SimpleGame extends FlameGame with TapCallbacks {
  late Player _player;

  @override
  Future<void> onLoad() async {
    _player = Player()
      ..position = size / 2
      ..anchor = Anchor.center;
    add(_player);
  }
}

/// A player component that moves when tapped.
class Player extends RectangleComponent with TapCallbacks {
  /// Creates a player.
  Player()
      : super(
          size: Vector2.all(50),
          paint: Paint()..color = Colors.blue,
        );

  /// Moves the player to the right.
  void move() {
    position += Vector2(20, 0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    move();
  }
}
