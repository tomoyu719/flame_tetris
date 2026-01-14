# Flame Tetris - 基本設計書

## 1. システム概要

### 1.1 プロジェクト情報

| 項目 | 内容 |
|------|------|
| プロジェクト名 | Flame Tetris |
| 目的 | 趣味・技術実験（Flutter/Flame/Clean Architecture学習） |
| バージョン | v1.0.0 |

### 1.2 ターゲットプラットフォーム

| プラットフォーム | 操作方法 |
|------------------|----------|
| Web（Chrome等） | キーボード |
| iOS / Android | タッチボタンUI |
| macOS / Windows | キーボード |

### 1.3 技術スタック

| 分類 | 技術 | 用途 |
|------|------|------|
| フレームワーク | Flutter | クロスプラットフォームUI |
| ゲームエンジン | Flame | 2Dゲーム描画・ゲームループ |
| 状態管理 | Riverpod 1.x | DI・状態管理 |
| ルーティング | go_router | 画面遷移 |
| ローカル保存 | SharedPreferences | 設定・スコア永続化 |
| オーディオ | flame_audio | BGM・効果音再生 |
| テスト | flutter_test, flame_test | 単体・ウィジェットテスト |

---

## 2. 画面構成

### 2.1 画面遷移図

```
                    ┌──────────────┐
                    │ アプリ起動   │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
          ┌────────│  タイトル画面 │◀──────────┐
          │        └──────┬───────┘           │
          │               │                    │
          │        START  │                    │ GO TITLE
          │               ▼                    │
          │        ┌──────────────┐            │
          │        │  ゲーム画面   │────────────┤
          │        └──────┬───────┘            │
          │               │                    │
   SETTINGS               │ GAME OVER          │
          │               ▼                    │
          │        ┌──────────────┐            │
          │        │ゲームオーバー │────────────┘
          │        └──────┬───────┘
          │               │ RETRY
          │               └──────────▶ ゲーム画面
          ▼
   ┌──────────────┐
   │   設定画面   │
   └──────┬───────┘
          │ BACK
          └────────────────────────▶ 呼び出し元に戻る
```

### 2.2 画面一覧

| 画面 | 説明 | ルート |
|------|------|--------|
| タイトル | START、SETTINGS、HIGH SCOREメニュー | `/` |
| ゲーム | メインプレイ画面（Flame描画） | `/game` |
| ポーズ | ゲーム画面上にオーバーレイ表示 | - |
| ゲームオーバー | スコア表示、RETRY、GO TITLE | `/game-over` |
| 設定 | 音量、ゴースト表示ON/OFF | `/settings` |

---

## 3. 機能概要

### 3.1 コアゲーム機能

| 機能 | 説明 |
|------|------|
| テトリミノ落下 | 7種類のテトリミノが上から落下 |
| 移動・回転 | 左右移動、左右回転（SRS壁蹴り対応） |
| ハードドロップ | 瞬時に最下部まで落下 |
| ソフトドロップ | 加速落下 |
| ライン消去 | 横一列揃うと消去（1〜4ライン同時可） |
| NEXT表示 | 次に来る3つのテトリミノを表示 |
| HOLD機能 | 現在のテトリミノを保持・入れ替え |
| ゴーストピース | 落下予定位置を半透明表示 |
| レベルアップ | 10ライン消去ごとにレベル＆速度上昇 |

### 3.2 スコア機能

| 機能 | 説明 |
|------|------|
| スコア計算 | ライン消去・ドロップによる得点計算 |
| ハイスコア | ローカルに最高スコアを保存 |
| 新記録表示 | ゲームオーバー時に更新があれば表示 |

### 3.3 設定機能

| 機能 | 説明 |
|------|------|
| BGM音量 | 0〜100%で調整 |
| SE音量 | 0〜100%で調整 |
| ゴースト表示 | ON/OFF切り替え |
| ハイスコアリセット | 確認ダイアログ付きでリセット |

### 3.4 オーディオ機能

| 種類 | 内容 |
|------|------|
| BGM | メインテーマ（ループ再生） |
| 効果音 | 移動、回転、ドロップ、ライン消去、Tetris、レベルアップ、ゲームオーバー |

---

## 4. アーキテクチャ

### 4.1 基本方針

**Clean Architecture + Feature First** を採用。

- **Domain層**: ビジネスロジック（Pure Dart、フレームワーク非依存）
- **Application層**: ユースケース（Eitherによるエラーハンドリング）
- **Presentation層**: UI（Flutter/Flame）
- **Infrastructure層**: 外部サービス実装（SharedPreferences等）

### 4.2 ディレクトリ構成

```
lib/
├── core/           # 共通基盤
│   ├── errors/     #   Failure定義
│   └── utils/      #   ユーティリティ
├── shared/         # 共有リソース
│   ├── widgets/    #   共通Widget
│   ├── theme/      #   テーマ定義
│   └── router/     #   go_router設定
├── features/       # 機能モジュール
│   ├── game/       #   ゲーム機能
│   ├── score/      #   スコア機能
│   ├── settings/   #   設定機能
│   ├── title/      #   タイトル画面
│   ├── game_over/  #   ゲームオーバー画面
│   └── audio/      #   オーディオ機能
└── di/             # Provider統合
```

### 4.3 Feature内部構成（gameの例）

```
features/game/
├── domain/
│   ├── entities/       # Tetromino, Board, GameState等
│   ├── enums/          # TetrominoType, GameStatus等
│   ├── services/       # Collision, Rotation, LineClear, Scoring
│   └── value_objects/  # Level, LinesCleared
├── application/
│   ├── usecases/       # Move, Rotate, HardDrop, Hold, GameTick等
│   └── services/       # TetrominoGenerator
├── presentation/
│   ├── flame/          # TetrisGame, Components
│   ├── screens/        # GameScreen
│   ├── widgets/        # ScorePanel, NextPanel, HoldPanel等
│   └── controllers/    # GameController
└── providers/          # Riverpod Provider定義
```

### 4.4 レイヤー依存ルール

```
✅ presentation → application → domain
❌ domain → presentation（逆方向禁止）
❌ domain → Flutter/Flame（フレームワーク依存禁止）
```

### 4.5 依存関係図

```
┌────────────────────────────────────────────────────────┐
│                    Providers (di/)                      │
├────────────────────────────────────────────────────────┤
│  game_providers  │  score_providers  │  settings_providers
├────────────────────────────────────────────────────────┤
│                   Application Layer                     │
│  GameUseCases    │  ScoreUseCases    │  SettingsUseCases
├────────────────────────────────────────────────────────┤
│                     Domain Layer                        │
│  Entities: Tetromino, Board, GameState, HighScore      │
│  Services: Collision, Rotation, LineClear, Scoring     │
│  ValueObjects: Level, LinesCleared                     │
├────────────────────────────────────────────────────────┤
│                 Infrastructure Layer                    │
│  ScoreRepositoryImpl  │  SettingsRepositoryImpl        │
│           (SharedPreferences)                          │
└────────────────────────────────────────────────────────┘
```

---

## 5. ゲームルール概要

### 5.1 スコア計算

| アクション | 基本点 | 計算式 |
|------------|--------|--------|
| Single（1ライン） | 100 | 100 × Level |
| Double（2ライン） | 300 | 300 × Level |
| Triple（3ライン） | 500 | 500 × Level |
| Tetris（4ライン） | 800 | 800 × Level |
| ソフトドロップ | 1/マス | 落下距離 × 1 |
| ハードドロップ | 2/マス | 落下距離 × 2 |

### 5.2 レベルシステム

- **レベルアップ条件**: 10ライン消去ごと
- **最大レベル**: 15
- **落下速度**: Level 1（1.0秒/マス）→ Level 15（0.1秒/マス）

### 5.3 テトリミノ生成

**7-bagアルゴリズム**採用：
- 7種類をシャッフルしたバッグから順番に取り出し
- 同じミノの連続出現を抑制
- 最大12個の間隔で必ず全種類出現

### 5.4 回転システム

**SRS（Super Rotation System）**採用：
- 5段階の壁蹴りテストで回転を試行
- Iミノと他ミノで異なる壁蹴りテーブル

### 5.5 ロックダウン

**Extended Lock Down**方式：
- 着地後0.5秒で固定
- 移動/回転で猶予リセット（最大15回）

### 5.6 ゲームオーバー条件

新しいテトリミノがスポーン位置で衝突した場合にゲームオーバー。

---

## 6. 操作方法概要

### 6.1 PC（キーボード）

| キー | 操作 |
|------|------|
| ← → | 左右移動 |
| ↓ | ソフトドロップ |
| ↑ / X | 右回転 |
| Z | 左回転 |
| Space | ハードドロップ |
| C | ホールド |
| Esc / P | ポーズ |

### 6.2 モバイル（タッチUI）

| ボタン | 操作 |
|--------|------|
| ↺ / ↻ | 左右回転 |
| ◀ / ▶ | 左右移動 |
| ▼ | ソフトドロップ |
| ⬇⬇ | ハードドロップ |
| HOLD | ホールド |

---

## 7. 詳細設計書

各機能の詳細設計は以下のドキュメントを参照してください。

| 機能 | ファイル | 内容 |
|------|----------|------|
| タイトル | [docs/design/title.md](docs/design/title.md) | ワイヤーフレーム、Widget実装 |
| ゲーム | [docs/design/game.md](docs/design/game.md) | Domain/Application/Presentation層、Entity/Service/UseCase設計 |
| ゲームオーバー | [docs/design/game_over.md](docs/design/game_over.md) | ワイヤーフレーム、スコア表示、Widget実装 |
| 設定 | [docs/design/settings.md](docs/design/settings.md) | GameSettings、Repository、Provider設計 |
| スコア | [docs/design/score.md](docs/design/score.md) | HighScore、Repository、UseCase設計 |
| オーディオ | [docs/design/audio.md](docs/design/audio.md) | AudioService、BGM/SE再生実装 |
| 付録 | [docs/design/appendix.md](docs/design/appendix.md) | テトリミノ形状、SRS壁蹴り、7-bag、ロックダウン |

---

## 8. 主要エンティティ

### 8.1 Tetromino（テトリミノ）

```dart
@immutable
class Tetromino {
  final TetrominoType type;      // I, O, T, S, Z, J, L
  final Position position;        // ボード上の位置
  final RotationState rotation;   // 0°, 90°, 180°, 270°

  List<Position> get cells;       // 相対座標
  List<Position> get absoluteCells; // 絶対座標
}
```

### 8.2 Board（ボード）

```dart
@immutable
class Board {
  static const int width = 10;
  static const int height = 20;
  static const int bufferHeight = 4;  // 見えない領域

  final List<List<TetrominoType?>> grid;
}
```

### 8.3 GameState（ゲーム状態）

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
  final GameStatus status;  // ready, playing, paused, gameOver
  final bool canHold;
}
```

---

## 9. 関連ドキュメント

| ドキュメント | 説明 |
|--------------|------|
| [CLAUDE.md](CLAUDE.md) | プロジェクト指示書（開発ルール・コマンド） |
| [ARCHITECTURE.md](ARCHITECTURE.md) | アーキテクチャ詳細 |
| [README.md](README.md) | プロジェクト概要・セットアップ手順 |
