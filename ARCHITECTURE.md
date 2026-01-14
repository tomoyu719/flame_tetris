# Flame Tetris - アーキテクチャ設計書

## 概要

| 項目           | 内容                               |
| -------------- | ---------------------------------- |
| アーキテクチャ | Clean Architecture + Feature First |
| 状態管理       | Riverpod                           |
| ゲームエンジン | Flame                              |
| ローカル保存   | SharedPreferences                  |

```
依存の方向: Presentation → Application → Domain ← Infrastructure

┌─────────────────────────────────────────────────┐
│              Presentation (Flame/Flutter)        │
│  ┌───────────────────────────────────────────┐  │
│  │           Application (UseCases)           │  │
│  │  ┌─────────────────────────────────────┐  │  │
│  │  │      Domain (Entities/Services)      │  │  │
│  │  └─────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────┘  │
│              Infrastructure (Repositories)       │
└─────────────────────────────────────────────────┘
```

---

## ディレクトリ構成

```
lib/
├── main.dart
├── app.dart
├── core/                           # 共通基盤
│   ├── constants/
│   ├── errors/                     # Failure, Exception
│   └── utils/                      # Either型など
├── shared/                         # 共有コンポーネント
│   ├── widgets/
│   ├── theme/
│   └── router/
├── features/                       # 機能モジュール
│   ├── game/                       # ===== ゲーム機能 =====
│   │   ├── domain/
│   │   │   ├── entities/           # Tetromino, Board, GameState
│   │   │   ├── enums/              # TetrominoType, RotationState
│   │   │   ├── services/           # CollisionService, RotationService
│   │   │   └── value_objects/      # Level, LinesCleared
│   │   ├── application/
│   │   │   ├── usecases/           # Move, Rotate, HardDrop, Hold, GameTick
│   │   │   └── services/           # TetrominoGenerator
│   │   ├── presentation/
│   │   │   ├── flame/              # TetrisGame, Components
│   │   │   ├── screens/
│   │   │   ├── widgets/            # ScorePanel, MobileControls
│   │   │   └── controllers/        # GameController
│   │   └── providers/
│   ├── score/                      # ===== スコア機能 =====
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/       # ScoreRepository (interface)
│   │   ├── application/usecases/
│   │   ├── infrastructure/         # ScoreRepositoryImpl
│   │   └── providers/
│   ├── settings/                   # ===== 設定機能 =====
│   │   ├── domain/
│   │   ├── application/
│   │   ├── infrastructure/
│   │   ├── presentation/
│   │   └── providers/
│   ├── title/                      # タイトル画面
│   │   └── presentation/
│   ├── game_over/                  # ゲームオーバー画面
│   │   └── presentation/
│   └── audio/                      # オーディオ機能
│       ├── domain/services/
│       ├── infrastructure/
│       └── providers/
└── di/                             # Provider統合

test/
├── features/                       # 機能別テスト（lib/と同構造）
│   ├── game/
│   │   ├── domain/
│   │   ├── application/
│   │   └── presentation/
│   ├── score/
│   └── settings/
├── integration/
├── mocks/
└── fixtures/
```

### 機能間の依存ルール

```
✅ 許可                              ❌ 禁止
───────────────────────────────      ───────────────────────────────
presentation → domain (同一feature)   domain → presentation
application  → domain (同一feature)   domain → package:flutter
presentation → 他feature/domain       presentation → 他feature/presentation
全feature    → core/, shared/         core/ → features/
```

---

## クラス図

### Domain Layer

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Tetromino   │  │    Board     │  │  GameState   │
├──────────────┤  ├──────────────┤  ├──────────────┤
│ type         │  │ grid[20][10] │  │ board        │
│ position     │  │ width=10     │  │ current      │
│ rotation     │  │ height=20    │  │ held         │
├──────────────┤  ├──────────────┤  │ nextQueue[3] │
│ cells        │  │ getCell()    │  │ score, level │
│ move()       │  │ place()      │  │ status       │
│ rotate()     │  │ clearLines() │  │ canHold      │
└──────────────┘  └──────────────┘  └──────────────┘

┌─────────────────────────────────────────────────────────────┐
│ <<interface>> CollisionService                               │
├─────────────────────────────────────────────────────────────┤
│ isValidPosition(board, tetromino): bool                      │
└─────────────────────────────────────────────────────────────┘
           △ implements
┌─────────────────────────────────────────────────────────────┐
│ CollisionServiceImpl                                         │
└─────────────────────────────────────────────────────────────┘

他のService: RotationService, LineClearService, ScoringService
```

### Application Layer

```
┌────────────────────┐  ┌────────────────────┐
│ MoveTetrominoUC    │  │ RotateTetrominoUC  │
├────────────────────┤  ├────────────────────┤
│ execute(state,dir) │  │ execute(state,dir) │
│ → Either<F,GS>     │  │ → Either<F,GS>     │
└────────────────────┘  └────────────────────┘

┌────────────────────┐  ┌────────────────────┐
│ HardDropUseCase    │  │ HoldTetrominoUC    │
├────────────────────┤  ├────────────────────┤
│ execute(state)     │  │ execute(state)     │
└────────────────────┘  └────────────────────┘

┌─────────────────────────────────────────────┐
│ GameTickUseCase                              │
├─────────────────────────────────────────────┤
│ execute(state) → 自動落下 or 着地処理         │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ TetrominoGenerator (7-bag)                   │
├─────────────────────────────────────────────┤
│ getNext(), peekNext(count)                   │
└─────────────────────────────────────────────┘
```

### Presentation Layer

```
┌────────────────────────────────────────────────────────────┐
│ TetrisGame (FlameGame)                                      │
├────────────────────────────────────────────────────────────┤
│ BoardComponent, TetrominoComponent, GhostComponent          │
│ updateGameState(state)                                      │
└────────────────────────────────────────────────────────────┘
                              │ uses
                              ▼
┌────────────────────────────────────────────────────────────┐
│ GameController (ChangeNotifier)                             │
├────────────────────────────────────────────────────────────┤
│ move(), rotate(), hardDrop(), hold(), startGame()           │
│ → UseCase実行 → state更新 → notifyListeners()              │
└────────────────────────────────────────────────────────────┘
```

---

## シーケンス図

### テトリミノ移動

```
User → InputHandler → GameController → MoveTetrominoUC → CollisionService
                                    ←─ Either<Failure, GameState> ─┘
                      ← notifyListeners()
```

### ゲームティック（自動落下）

```
Timer → GameController → GameTickUseCase
                              │
                              ├─ CollisionService.isValidPosition()
                              │   └─ false (着地)
                              ├─ Board.placeTetromino()
                              ├─ LineClearService.getCompletedLines()
                              ├─ ScoringService.calculate()
                              └─ Generator.getNext()
                      ← Either<Failure, GameState>
```

---

## 付録

### スコア計算

| アクション | 基本点 | 計算式      |
| ---------- | ------ | ----------- |
| Single     | 100    | 100 × Level |
| Double     | 300    | 300 × Level |
| Triple     | 500    | 500 × Level |
| Tetris     | 800    | 800 × Level |
| SoftDrop   | 1/マス | 距離 × 1    |
| HardDrop   | 2/マス | 距離 × 2    |

### レベル

- 10 ライン消去でレベルアップ
- Level 1: 1.0 秒/マス → Level 15: 0.1 秒/マス

---

## アーキテクチャテスト

```bash
flutter test test/architecture_test.dart
```

### 検証ルール（15項目）

| レイヤー | ルール |
|----------|--------|
| Domain | Flutter/Flame依存禁止、外部レイヤー依存禁止 |
| Application | presentation/infrastructure依存禁止 |
| Infrastructure | presentation依存禁止 |
| Core/Shared | features依存禁止 |
| Feature間 | 他featureのpresentation依存禁止 |

### CI設定例

```yaml
- name: Architecture Test
  run: flutter test test/architecture_test.dart
```
