# 付録

[← 設計書トップ](../../DESIGN.md)

---

## A. テトリミノ（7種）

```
I ミノ:  ████        O ミノ:  ██
                              ██

T ミノ:   █          S ミノ:   ██
         ███                  ██

Z ミノ:  ██          J ミノ:  █
          ██                  ███

L ミノ:    █
         ███
```

### 色定義

| ミノ | 色 | カラーコード |
|------|-----|-------------|
| I | シアン | `#00FFFF` |
| O | イエロー | `#FFFF00` |
| T | パープル | `#800080` |
| S | グリーン | `#00FF00` |
| Z | レッド | `#FF0000` |
| J | ブルー | `#0000FF` |
| L | オレンジ | `#FFA500` |

### 形状定義

```dart
const tetrominoShapes = {
  TetrominoType.I: {
    RotationState.deg0:   [Position(-1, 0), Position(0, 0), Position(1, 0), Position(2, 0)],
    RotationState.deg90:  [Position(0, -1), Position(0, 0), Position(0, 1), Position(0, 2)],
    RotationState.deg180: [Position(-1, 0), Position(0, 0), Position(1, 0), Position(2, 0)],
    RotationState.deg270: [Position(0, -1), Position(0, 0), Position(0, 1), Position(0, 2)],
  },
  TetrominoType.O: {
    RotationState.deg0:   [Position(0, 0), Position(1, 0), Position(0, 1), Position(1, 1)],
    RotationState.deg90:  [Position(0, 0), Position(1, 0), Position(0, 1), Position(1, 1)],
    RotationState.deg180: [Position(0, 0), Position(1, 0), Position(0, 1), Position(1, 1)],
    RotationState.deg270: [Position(0, 0), Position(1, 0), Position(0, 1), Position(1, 1)],
  },
  TetrominoType.T: {
    RotationState.deg0:   [Position(0, 0), Position(-1, 0), Position(1, 0), Position(0, -1)],
    RotationState.deg90:  [Position(0, 0), Position(0, -1), Position(0, 1), Position(1, 0)],
    RotationState.deg180: [Position(0, 0), Position(-1, 0), Position(1, 0), Position(0, 1)],
    RotationState.deg270: [Position(0, 0), Position(0, -1), Position(0, 1), Position(-1, 0)],
  },
  TetrominoType.S: {
    RotationState.deg0:   [Position(0, 0), Position(1, 0), Position(0, 1), Position(-1, 1)],
    RotationState.deg90:  [Position(0, 0), Position(0, -1), Position(1, 0), Position(1, 1)],
    RotationState.deg180: [Position(0, 0), Position(1, 0), Position(0, 1), Position(-1, 1)],
    RotationState.deg270: [Position(0, 0), Position(0, -1), Position(1, 0), Position(1, 1)],
  },
  TetrominoType.Z: {
    RotationState.deg0:   [Position(0, 0), Position(-1, 0), Position(0, 1), Position(1, 1)],
    RotationState.deg90:  [Position(0, 0), Position(1, 0), Position(0, -1), Position(1, 1)],
    RotationState.deg180: [Position(0, 0), Position(-1, 0), Position(0, 1), Position(1, 1)],
    RotationState.deg270: [Position(0, 0), Position(1, 0), Position(0, -1), Position(1, 1)],
  },
  TetrominoType.J: {
    RotationState.deg0:   [Position(0, 0), Position(-1, 0), Position(1, 0), Position(-1, -1)],
    RotationState.deg90:  [Position(0, 0), Position(0, -1), Position(0, 1), Position(1, -1)],
    RotationState.deg180: [Position(0, 0), Position(-1, 0), Position(1, 0), Position(1, 1)],
    RotationState.deg270: [Position(0, 0), Position(0, -1), Position(0, 1), Position(-1, 1)],
  },
  TetrominoType.L: {
    RotationState.deg0:   [Position(0, 0), Position(-1, 0), Position(1, 0), Position(1, -1)],
    RotationState.deg90:  [Position(0, 0), Position(0, -1), Position(0, 1), Position(1, 1)],
    RotationState.deg180: [Position(0, 0), Position(-1, 0), Position(1, 0), Position(-1, 1)],
    RotationState.deg270: [Position(0, 0), Position(0, -1), Position(0, 1), Position(-1, -1)],
  },
};
```

---

## B. SRS壁蹴りテーブル

SRS（Super Rotation System）は、テトリミノの回転時に壁や床との衝突を回避するためのシステムです。

### 回転状態の記号

| 記号 | 状態 | 角度 |
|------|------|------|
| 0 | 初期状態 | 0° |
| R | 右回転後 | 90° |
| 2 | 180°回転後 | 180° |
| L | 左回転後 | 270° |

### J, L, S, T, Z ミノ

| 状態遷移 | Test 1 | Test 2 | Test 3 | Test 4 | Test 5 |
|----------|--------|--------|--------|--------|--------|
| 0→R | (0,0) | (-1,0) | (-1,+1) | (0,-2) | (-1,-2) |
| R→0 | (0,0) | (+1,0) | (+1,-1) | (0,+2) | (+1,+2) |
| R→2 | (0,0) | (+1,0) | (+1,-1) | (0,+2) | (+1,+2) |
| 2→R | (0,0) | (-1,0) | (-1,+1) | (0,-2) | (-1,-2) |
| 2→L | (0,0) | (+1,0) | (+1,+1) | (0,-2) | (+1,-2) |
| L→2 | (0,0) | (-1,0) | (-1,-1) | (0,+2) | (-1,+2) |
| L→0 | (0,0) | (-1,0) | (-1,-1) | (0,+2) | (-1,+2) |
| 0→L | (0,0) | (+1,0) | (+1,+1) | (0,-2) | (+1,-2) |

### I ミノ

| 状態遷移 | Test 1 | Test 2 | Test 3 | Test 4 | Test 5 |
|----------|--------|--------|--------|--------|--------|
| 0→R | (0,0) | (-2,0) | (+1,0) | (-2,-1) | (+1,+2) |
| R→0 | (0,0) | (+2,0) | (-1,0) | (+2,+1) | (-1,-2) |
| R→2 | (0,0) | (-1,0) | (+2,0) | (-1,+2) | (+2,-1) |
| 2→R | (0,0) | (+1,0) | (-2,0) | (+1,-2) | (-2,+1) |
| 2→L | (0,0) | (+2,0) | (-1,0) | (+2,+1) | (-1,-2) |
| L→2 | (0,0) | (-2,0) | (+1,0) | (-2,-1) | (+1,+2) |
| L→0 | (0,0) | (+1,0) | (-2,0) | (+1,-2) | (-2,+1) |
| 0→L | (0,0) | (-1,0) | (+2,0) | (-1,+2) | (+2,-1) |

### 座標系

- x: 右が正
- y: 上が正

### 壁蹴りアルゴリズム

```dart
Tetromino? tryRotate(Board board, Tetromino tetromino, RotationDirection dir) {
  final newRotation = tetromino.rotation.rotate(dir);
  final offsets = getWallKickOffsets(tetromino.type, tetromino.rotation, newRotation);

  for (final offset in offsets) {
    final candidate = tetromino.copyWith(
      rotation: newRotation,
      position: tetromino.position + offset,
    );
    if (isValidPosition(board, candidate)) {
      return candidate;
    }
  }

  return null; // 回転不可
}
```

---

## C. 7-bagアルゴリズム

7種類のテトリミノをシャッフルした「バッグ」から順番に取り出すことで、同じミノが連続して出にくくなります。

```dart
class TetrominoGenerator {
  final Random _random;
  final Queue<TetrominoType> _bag = Queue();

  TetrominoGenerator({Random? random}) : _random = random ?? Random();

  TetrominoType getNext() {
    if (_bag.isEmpty) {
      _refillBag();
    }
    return _bag.removeFirst();
  }

  List<TetrominoType> peekNext(int count) {
    while (_bag.length < count) {
      _refillBag();
    }
    return _bag.take(count).toList();
  }

  void _refillBag() {
    final types = TetrominoType.values.toList()..shuffle(_random);
    _bag.addAll(types);
  }
}
```

### 特性

- 各ミノは7回に1回は必ず出現
- 最悪ケースでも同じミノの間隔は最大12個
- テスト時はシード固定で再現可能

---

## D. ロックダウン仕様

テトリミノが着地してから固定されるまでの仕様です。

### Extended Lock Down

```dart
class LockDownTimer {
  static const maxMoves = 15;
  static const lockDelay = Duration(milliseconds: 500);

  int _moveCount = 0;
  Timer? _timer;

  void onLand(VoidCallback onLock) {
    _timer?.cancel();
    _timer = Timer(lockDelay, onLock);
  }

  void onMove() {
    if (_moveCount < maxMoves) {
      _moveCount++;
      _timer?.cancel();
      _timer = Timer(lockDelay, _lock);
    }
  }

  void reset() {
    _moveCount = 0;
    _timer?.cancel();
  }
}
```

### ルール

1. 着地後0.5秒で固定
2. 移動/回転で猶予リセット（最大15回）
3. 15回超過で即座に固定

---

## E. ゲームオーバー条件

```dart
bool isGameOver(Board board, Tetromino newTetromino) {
  // 新しいテトリミノがスポーン位置で衝突
  return !isValidPosition(board, newTetromino);
}
```

### スポーン位置

- I ミノ: (3, 0) - (6, 0)
- その他: (3, 0) - (5, 1)

中央上部に出現し、即座に衝突する場合はゲームオーバー。
