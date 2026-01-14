# game - ゲーム機能

[← 設計書トップ](../../DESIGN.md)

テトリスのコアゲームロジックを担当する最重要機能。

---

## ワイヤーフレーム

### 横画面レイアウト（Web/タブレット）

```
┌─────────────────────────────────────────────────────────────┐
│  ┌────────┐   ┌──────────────────────┐   ┌────────────────┐ │
│  │  HOLD  │   │                      │   │     NEXT       │ │
│  │ ┌────┐ │   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   ┌────────┐   │ │
│  │ │ T  │ │   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   │   1    │   │ │
│  │ └────┘ │   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   └────────┘   │ │
│  └────────┘   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   ┌────────┐   │ │
│               │ ▓▓░░░░░░▀▀░░░░░░░░▓▓ │   │   │   2    │   │ │
│  ┌────────┐   │ ▓▓░░░░░▀▀▀░░░░░░░░▓▓ │   │   └────────┘   │ │
│  │ SCORE  │   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   ┌────────┐   │ │
│  │ 12450  │   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   │   3    │   │ │
│  └────────┘   │ ▓▓░░░░░░░░░░░░░░░░▓▓ │   │   └────────┘   │ │
│  ┌────────┐   │ ▓▓░░░░░░░░▄▄▄▄░░░░▓▓ │   └────────────────┘ │
│  │ LEVEL  │   │ ▓▓░░░░██░░▄▄▄▄░░░░▓▓ │   ┌────────────────┐ │
│  │   5    │   │ ▓▓░░████░░████████▓▓ │   │   ▌▌ PAUSE     │ │
│  └────────┘   │ ▓▓████████████████▓▓ │   └────────────────┘ │
│  ┌────────┐   └──────────────────────┘                      │
│  │ LINES  │                                                 │
│  │   42   │   凡例: ▓▓=壁 ░░=空 ▀▀=落下中 ▄▄=ゴースト ██=設置済│
│  └────────┘                                                 │
└─────────────────────────────────────────────────────────────┘
```

### 縦画面レイアウト（モバイル）

```
┌─────────────────────────────┐
│  SCORE: 12450    LEVEL: 5   │
├─────────────────────────────┤
│ ┌─────┐ ┌───────────┐ ┌───┐ │
│ │HOLD │ │           │ │ N │ │
│ │ ┌─┐ │ │ ░░░░░░░░░░│ │ E │ │
│ │ │T│ │ │ ░░░░▀▀░░░░│ │ X │ │
│ │ └─┘ │ │ ░░░▀▀▀░░░░│ │ T │ │
│ └─────┘ │ ░░░░░░░░░░│ ├───┤ │
│         │ ░░░░▄▄░░░░│ │ 1 │ │
│         │ ░░░▄▄▄░░░░│ ├───┤ │
│         │ ░░░░░░██░░│ │ 2 │ │
│         │ ░░██████░░│ ├───┤ │
│         │ ████████░░│ │ 3 │ │
│         └───────────┘ └───┘ │
├─────────────────────────────┤
│    ┌───┐   ┌───┐   ┌───┐    │
│    │ ↺ │   │ ▲ │   │ ↻ │    │
│    └───┘   └───┘   └───┘    │
│  ┌───┐  ┌───┐  ┌───┐  ┌───┐ │
│  │ ◀ │  │ ▼ │  │ ▶ │  │⬇⬇│ │
│  └───┘  └───┘  └───┘  └───┘ │
│         ┌─────────┐         │
│         │  HOLD   │         │
│         └─────────┘         │
└─────────────────────────────┘
```

---

## 操作方法

### PC（キーボード）

| キー | 操作 |
|------|------|
| ← → | 左右移動 |
| ↓ | ソフトドロップ |
| ↑ / X | 右回転 |
| Z | 左回転 |
| Space | ハードドロップ |
| C | ホールド |
| Esc / P | ポーズ |

### モバイル（ボタンUI）

| ボタン | 操作 |
|--------|------|
| ↺ | 左回転 |
| ↻ | 右回転 |
| ◀ ▶ | 左右移動 |
| ▼ | ソフトドロップ |
| ⬇⬇ | ハードドロップ |
| HOLD | ホールド |

---

## ポーズ画面（オーバーレイ）

```
┌─────────────────────────────────────┐
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░░░░░░░┌─────────────────┐░░░░░░░░░│
│░░░░░░░░░│     PAUSED      │░░░░░░░░░│
│░░░░░░░░░└─────────────────┘░░░░░░░░░│
│░░░░░░░░░┌─────────────────┐░░░░░░░░░│
│░░░░░░░░░│     RESUME      │░░░░░░░░░│
│░░░░░░░░░└─────────────────┘░░░░░░░░░│
│░░░░░░░░░┌─────────────────┐░░░░░░░░░│
│░░░░░░░░░│    SETTINGS     │░░░░░░░░░│
│░░░░░░░░░└─────────────────┘░░░░░░░░░│
│░░░░░░░░░┌─────────────────┐░░░░░░░░░│
│░░░░░░░░░│    GO TITLE     │░░░░░░░░░│
│░░░░░░░░░└─────────────────┘░░░░░░░░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
└─────────────────────────────────────┘
```

---

## ディレクトリ構成

```
features/game/
├── domain/
│   ├── entities/
│   │   ├── tetromino.dart
│   │   ├── board.dart
│   │   ├── game_state.dart
│   │   └── position.dart
│   ├── enums/
│   │   ├── tetromino_type.dart
│   │   ├── rotation_state.dart
│   │   ├── move_direction.dart
│   │   └── game_status.dart
│   ├── services/
│   │   ├── collision_service.dart
│   │   ├── rotation_service.dart
│   │   ├── line_clear_service.dart
│   │   └── scoring_service.dart
│   └── value_objects/
│       ├── level.dart
│       └── lines_cleared.dart
├── application/
│   ├── usecases/
│   │   ├── move_tetromino_usecase.dart
│   │   ├── rotate_tetromino_usecase.dart
│   │   ├── hard_drop_usecase.dart
│   │   ├── soft_drop_usecase.dart
│   │   ├── hold_tetromino_usecase.dart
│   │   ├── game_tick_usecase.dart
│   │   └── start_game_usecase.dart
│   └── services/
│       └── tetromino_generator.dart
├── presentation/
│   ├── flame/
│   │   ├── tetris_game.dart
│   │   └── components/
│   │       ├── board_component.dart
│   │       ├── tetromino_component.dart
│   │       ├── ghost_component.dart
│   │       └── cell_component.dart
│   ├── screens/
│   │   └── game_screen.dart
│   ├── widgets/
│   │   ├── score_panel.dart
│   │   ├── next_panel.dart
│   │   ├── hold_panel.dart
│   │   └── mobile_controls.dart
│   └── controllers/
│       └── game_controller.dart
└── providers/
    ├── game_controller_provider.dart
    └── game_state_provider.dart
```

---

## Domain層

### Entities

#### Tetromino

```dart
@immutable
class Tetromino {
  final TetrominoType type;
  final Position position;
  final RotationState rotation;

  List<Position> get cells;           // 相対座標
  List<Position> get absoluteCells;   // 絶対座標

  Tetromino move(MoveDirection direction);
  Tetromino rotate(RotationDirection direction);
  Tetromino copyWith({...});
}
```

#### Board

```dart
@immutable
class Board {
  static const int width = 10;
  static const int height = 20;
  static const int bufferHeight = 4;

  final List<List<TetrominoType?>> grid;

  TetrominoType? getCell(int row, int col);
  Board placeTetrominoAt(Tetromino tetromino);
  Board clearLines(List<int> lineIndices);
}
```

#### GameState

```dart
@immutable
class GameState {
  final Board board;
  final Tetromino? currentTetromino;
  final Tetromino? heldTetromino;
  final List<TetrominoType> nextQueue;
  final int score;
  final int level;
  final int linesCleared;
  final GameStatus status;
  final bool canHold;
}
```

### Enums

```dart
enum TetrominoType { I, O, T, S, Z, J, L }
enum RotationState { deg0, deg90, deg180, deg270 }
enum MoveDirection { left, right, down }
enum RotationDirection { clockwise, counterClockwise }
enum GameStatus { ready, playing, paused, gameOver }
```

### Services

```dart
abstract class CollisionService {
  bool isValidPosition(Board board, Tetromino tetromino);
}

abstract class RotationService {
  Tetromino? tryRotate(Board board, Tetromino tetromino, RotationDirection dir, CollisionService collision);
}

abstract class LineClearService {
  List<int> getCompletedLines(Board board);
  Board clearLines(Board board, List<int> lineIndices);
}

abstract class ScoringService {
  int calculateLineClearScore(int lineCount, int level);
  int calculateSoftDropScore(int cellsDropped);
  int calculateHardDropScore(int cellsDropped);
}
```

---

## Application層

### UseCases

```dart
class MoveTetrominoUseCase {
  Either<Failure, GameState> execute(GameState state, MoveDirection direction);
}

class RotateTetrominoUseCase {
  Either<Failure, GameState> execute(GameState state, RotationDirection direction);
}

class HardDropUseCase {
  Either<Failure, GameState> execute(GameState state);
}

class HoldTetrominoUseCase {
  Either<Failure, GameState> execute(GameState state);
}

class GameTickUseCase {
  Either<Failure, GameState> execute(GameState state);
}
```

### TetrominoGenerator（7-bag）

```dart
class TetrominoGenerator {
  TetrominoType getNext();
  List<TetrominoType> peekNext(int count);
}
```

---

## Presentation層

### TetrisGame

```dart
class TetrisGame extends FlameGame with KeyboardEvents {
  late BoardComponent boardComponent;
  late TetrominoComponent tetrominoComponent;
  late GhostComponent ghostComponent;

  void updateGameState(GameState state);
}
```

### GameController

```dart
class GameController extends ChangeNotifier {
  GameState get state;
  void startGame();
  void move(MoveDirection direction);
  void rotate(RotationDirection direction);
  void hardDrop();
  void hold();
  void pause();
  void resume();
}
```

---

## テスト方針

| 対象 | 内容 | 優先度 |
|------|------|--------|
| Tetromino | 移動・回転、セル計算 | 高 |
| Board | 設置、ライン消去 | 高 |
| CollisionService | 衝突判定 | 高 |
| RotationService | SRS壁蹴り | 高 |
| MoveTetrominoUseCase | 正常移動・壁衝突 | 高 |
| GameTickUseCase | 落下・着地・ゲームオーバー | 高 |
