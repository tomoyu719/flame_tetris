import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('GameAction', () {
    test('全てのゲームアクションが定義されている', () {
      expect(GameAction.values, hasLength(9));
      expect(GameAction.values, contains(GameAction.moveLeft));
      expect(GameAction.values, contains(GameAction.moveRight));
      expect(GameAction.values, contains(GameAction.softDrop));
      expect(GameAction.values, contains(GameAction.hardDrop));
      expect(GameAction.values, contains(GameAction.rotateClockwise));
      expect(GameAction.values, contains(GameAction.rotateCounterClockwise));
      expect(GameAction.values, contains(GameAction.hold));
      expect(GameAction.values, contains(GameAction.pause));
      expect(GameAction.values, contains(GameAction.restart));
    });
  });

  group('KeyBindings', () {
    group('コンストラクタ', () {
      test('デフォルト値で生成できる', () {
        final bindings = KeyBindings();

        expect(bindings.getKey(GameAction.moveLeft), 'ArrowLeft');
        expect(bindings.getKey(GameAction.moveRight), 'ArrowRight');
        expect(bindings.getKey(GameAction.softDrop), 'ArrowDown');
        expect(bindings.getKey(GameAction.hardDrop), 'Space');
        expect(bindings.getKey(GameAction.rotateClockwise), 'ArrowUp');
        expect(bindings.getKey(GameAction.rotateCounterClockwise), 'KeyZ');
        expect(bindings.getKey(GameAction.hold), 'KeyC');
        expect(bindings.getKey(GameAction.pause), 'Escape');
        expect(bindings.getKey(GameAction.restart), 'KeyR');
      });

      test('カスタム値で生成できる', () {
        final bindings = KeyBindings(
          bindings: {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
          },
        );

        expect(bindings.getKey(GameAction.moveLeft), 'KeyA');
        expect(bindings.getKey(GameAction.moveRight), 'KeyD');
        // 指定していないものはデフォルト値
        expect(bindings.getKey(GameAction.softDrop), 'ArrowDown');
      });
    });

    group('getAction', () {
      test('キーからアクションを取得できる', () {
        final bindings = KeyBindings();

        expect(bindings.getAction('ArrowLeft'), GameAction.moveLeft);
        expect(bindings.getAction('ArrowRight'), GameAction.moveRight);
        expect(bindings.getAction('Space'), GameAction.hardDrop);
      });

      test('存在しないキーはnullを返す', () {
        final bindings = KeyBindings();

        expect(bindings.getAction('Unknown'), isNull);
      });
    });

    group('copyWith', () {
      test('特定のキーバインドを変更できる', () {
        final original = KeyBindings();
        final modified = original.copyWith(
          bindings: {GameAction.moveLeft: 'KeyA'},
        );

        expect(modified.getKey(GameAction.moveLeft), 'KeyA');
        // 他は変更されない
        expect(modified.getKey(GameAction.moveRight), 'ArrowRight');
      });
    });

    group('JSON変換', () {
      test('toJsonで正しくシリアライズできる', () {
        final bindings = KeyBindings(
          bindings: {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
          },
        );

        final json = bindings.toJson();

        expect(json['moveLeft'], 'KeyA');
        expect(json['moveRight'], 'KeyD');
        expect(json['softDrop'], 'ArrowDown'); // デフォルト値
      });

      test('fromJsonで正しくデシリアライズできる', () {
        final json = {
          'moveLeft': 'KeyA',
          'moveRight': 'KeyD',
          'softDrop': 'KeyS',
        };

        final bindings = KeyBindings.fromJson(json);

        expect(bindings.getKey(GameAction.moveLeft), 'KeyA');
        expect(bindings.getKey(GameAction.moveRight), 'KeyD');
        expect(bindings.getKey(GameAction.softDrop), 'KeyS');
        // 指定されていないものはデフォルト値
        expect(bindings.getKey(GameAction.hardDrop), 'Space');
      });

      test('toJson→fromJsonで往復できる', () {
        final original = KeyBindings(
          bindings: {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
            GameAction.softDrop: 'KeyS',
            GameAction.hardDrop: 'KeyW',
          },
        );

        final restored = KeyBindings.fromJson(original.toJson());

        expect(restored.getKey(GameAction.moveLeft), 'KeyA');
        expect(restored.getKey(GameAction.moveRight), 'KeyD');
        expect(restored.getKey(GameAction.softDrop), 'KeyS');
        expect(restored.getKey(GameAction.hardDrop), 'KeyW');
      });
    });

    group('等価性', () {
      test('同じバインドのKeyBindingsは等しい', () {
        final bindings1 = KeyBindings();
        final bindings2 = KeyBindings();

        expect(bindings1, equals(bindings2));
      });

      test('異なるバインドのKeyBindingsは等しくない', () {
        final bindings1 = KeyBindings();
        final bindings2 = KeyBindings(
          bindings: {GameAction.moveLeft: 'KeyA'},
        );

        expect(bindings1, isNot(equals(bindings2)));
      });
    });
  });
}
