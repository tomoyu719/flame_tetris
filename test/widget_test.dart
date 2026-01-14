import 'dart:math';

import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';
import 'package:tetris_presentation/tetris_presentation.dart';

void main() {
  group('TetrisGame', () {
    late GameController controller;

    setUp(() {
      controller = _createTestController();
    });

    testWithGame<TetrisGame>(
      'ゲーム開始時にBoardComponentが追加される',
      () => TetrisGame(controller: controller, cellSize: 30.0),
      (game) async {
        await game.ready();

        // BoardComponentが存在することを確認
        final boardComponents =
            game.children.whereType<BoardComponent>().toList();
        expect(boardComponents.length, equals(1));
      },
    );

    testWithGame<TetrisGame>(
      'autoStart=trueでゲームが自動開始される',
      () => TetrisGame(
        controller: controller,
        cellSize: 30.0,
        autoStart: true,
      ),
      (game) async {
        await game.ready();

        // ゲームがプレイ中であることを確認
        expect(game.isPlaying, isTrue);
      },
    );

    testWithGame<TetrisGame>(
      'autoStart=falseではゲームが自動開始されない',
      () => TetrisGame(
        controller: controller,
        cellSize: 30.0,
        autoStart: false,
      ),
      (game) async {
        await game.ready();

        // ゲームがまだ開始されていないことを確認
        expect(game.isPlaying, isFalse);
      },
    );
  });

  group('GameScreen Widget', () {
    testWidgets('GameScreenが正常にレンダリングされる', (tester) async {
      final controller = _createTestController();
      final game = TetrisGame(
        controller: controller,
        cellSize: 30.0,
        autoStart: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GameScreen(game: game),
          ),
        ),
      );

      // GameWidgetが存在することを確認
      expect(find.byType(GameScreen), findsOneWidget);
    });
  });
}

/// テスト用のGameControllerを作成
GameController _createTestController() {
  final collisionService = CollisionServiceImpl();
  final rotationService = RotationServiceImpl(
    collisionService: collisionService,
  );
  final lineClearService = LineClearServiceImpl();
  final scoringService = ScoringServiceImpl();
  final generator = TetrominoGenerator(random: _FakeRandom());

  return GameController(
    generator: generator,
    collisionService: collisionService,
    rotationService: rotationService,
    lineClearService: lineClearService,
    scoringService: scoringService,
  );
}

/// テスト用の固定シード乱数
class _FakeRandom implements Random {
  int _counter = 0;

  @override
  int nextInt(int max) {
    return (_counter++) % max;
  }

  @override
  double nextDouble() => 0.5;

  @override
  bool nextBool() => true;
}
