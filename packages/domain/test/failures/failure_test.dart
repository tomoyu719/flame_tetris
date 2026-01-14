import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('Failure', () {
    group('GameFailure', () {
      test('CollisionFailureを生成できる', () {
        const failure = CollisionFailure();

        expect(failure, isA<GameFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, isNull);
      });

      test('メッセージ付きでCollisionFailureを生成できる', () {
        const failure = CollisionFailure(message: '壁と衝突しました');

        expect(failure.message, equals('壁と衝突しました'));
      });

      test('RotationFailureを生成できる', () {
        const failure = RotationFailure(message: '回転できません');

        expect(failure, isA<GameFailure>());
        expect(failure.message, equals('回転できません'));
      });

      test('MoveFailureを生成できる', () {
        const failure = MoveFailure();

        expect(failure, isA<GameFailure>());
      });

      test('GameOverFailureを生成できる', () {
        const failure = GameOverFailure(message: 'ゲームオーバー');

        expect(failure, isA<GameFailure>());
        expect(failure.message, equals('ゲームオーバー'));
      });

      test('HoldFailureを生成できる', () {
        const failure = HoldFailure(message: 'ホールドは1ターンに1回のみ');

        expect(failure, isA<GameFailure>());
        expect(failure.message, equals('ホールドは1ターンに1回のみ'));
      });

      test('InvalidOperationFailureを生成できる', () {
        const failure = InvalidOperationFailure(message: '無効な操作');

        expect(failure, isA<GameFailure>());
        expect(failure.message, equals('無効な操作'));
      });
    });

    group('等価性', () {
      test('同じ型・同じメッセージのFailureは等しい', () {
        const failure1 = CollisionFailure(message: 'test');
        const failure2 = CollisionFailure(message: 'test');

        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('同じ型・異なるメッセージのFailureは等しくない', () {
        const failure1 = CollisionFailure(message: 'test1');
        const failure2 = CollisionFailure(message: 'test2');

        expect(failure1, isNot(equals(failure2)));
      });

      test('異なる型のFailureは等しくない', () {
        const failure1 = CollisionFailure(message: 'test');
        const failure2 = RotationFailure(message: 'test');

        expect(failure1, isNot(equals(failure2)));
      });

      test('メッセージなしのFailureも比較できる', () {
        const failure1 = CollisionFailure();
        const failure2 = CollisionFailure();

        expect(failure1, equals(failure2));
      });
    });

    group('toString', () {
      test('メッセージなしの場合は型名のみ', () {
        const failure = CollisionFailure();

        expect(failure.toString(), equals('CollisionFailure'));
      });

      test('メッセージありの場合は型名とメッセージ', () {
        const failure = RotationFailure(message: 'エラー内容');

        expect(failure.toString(), equals('RotationFailure: エラー内容'));
      });
    });

    group('sealed class pattern', () {
      test('GameFailureのサブタイプを網羅的に処理できる', () {
        const failures = <GameFailure>[
          CollisionFailure(),
          RotationFailure(),
          MoveFailure(),
          GameOverFailure(),
          HoldFailure(),
          InvalidOperationFailure(),
        ];

        for (final failure in failures) {
          // sealed classにより、すべてのケースを網羅する必要がある
          final result = switch (failure) {
            CollisionFailure() => 'collision',
            RotationFailure() => 'rotation',
            MoveFailure() => 'move',
            GameOverFailure() => 'gameOver',
            HoldFailure() => 'hold',
            InvalidOperationFailure() => 'invalid',
          };

          expect(result, isNotEmpty);
        }
      });
    });
  });
}
