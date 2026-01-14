import 'package:meta/meta.dart';

/// ゲームのアクション種別
enum GameAction {
  /// 左移動
  moveLeft,

  /// 右移動
  moveRight,

  /// ソフトドロップ
  softDrop,

  /// ハードドロップ
  hardDrop,

  /// 時計回り回転
  rotateClockwise,

  /// 反時計回り回転
  rotateCounterClockwise,

  /// ホールド
  hold,

  /// ポーズ
  pause,

  /// リスタート
  restart,
}

/// キーバインド設定を表すエンティティ
///
/// 各ゲームアクションに割り当てられたキーを管理する。
/// キー名は文字列で保持し、プラットフォーム固有のキーコードとの
/// 変換はPresentation層で行う。
@immutable
class KeyBindings {
  /// KeyBindingsを生成
  ///
  /// [bindings]で指定されていないアクションはデフォルト値を使用する。
  KeyBindings({Map<GameAction, String>? bindings})
      : _bindings = {
          ..._defaultBindings,
          ...?bindings,
        };

  /// JSONからKeyBindingsを生成
  factory KeyBindings.fromJson(Map<String, dynamic> json) {
    final bindings = <GameAction, String>{};

    for (final action in GameAction.values) {
      final key = json[action.name] as String?;
      if (key != null) {
        bindings[action] = key;
      }
    }

    return KeyBindings(bindings: bindings);
  }

  /// デフォルトのキーバインド
  static const Map<GameAction, String> _defaultBindings = {
    GameAction.moveLeft: 'ArrowLeft',
    GameAction.moveRight: 'ArrowRight',
    GameAction.softDrop: 'ArrowDown',
    GameAction.hardDrop: 'Space',
    GameAction.rotateClockwise: 'ArrowUp',
    GameAction.rotateCounterClockwise: 'KeyZ',
    GameAction.hold: 'KeyC',
    GameAction.pause: 'Escape',
    GameAction.restart: 'KeyR',
  };

  final Map<GameAction, String> _bindings;

  /// 指定したアクションに割り当てられたキーを取得
  String getKey(GameAction action) {
    return _bindings[action] ?? _defaultBindings[action]!;
  }

  /// 指定したキーに割り当てられたアクションを取得
  ///
  /// 割り当てがない場合はnullを返す。
  GameAction? getAction(String key) {
    for (final entry in _bindings.entries) {
      if (entry.value == key) {
        return entry.key;
      }
    }
    return null;
  }

  /// 指定したバインドを変更した新しいKeyBindingsを返す
  KeyBindings copyWith({Map<GameAction, String>? bindings}) {
    return KeyBindings(
      bindings: {
        ..._bindings,
        ...?bindings,
      },
    );
  }

  /// JSONに変換
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    for (final action in GameAction.values) {
      json[action.name] = getKey(action);
    }
    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! KeyBindings) return false;

    for (final action in GameAction.values) {
      if (getKey(action) != other.getKey(action)) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      GameAction.values.map((action) => getKey(action)),
    );
  }

  @override
  String toString() {
    return 'KeyBindings($_bindings)';
  }
}
