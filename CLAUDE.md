# Flame Tetris - プロジェクト指示書

このファイルはClaude Codeがプロジェクトを理解するための指示書です。

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| プロジェクト名 | Flame Tetris |
| 目的 | 趣味・技術実験（Flutter/Flame/Clean Architecture学習） |
| プラットフォーム | Web, iOS, Android, macOS, Windows |

## 技術スタック

| 分類 | 技術 | 用途 |
|------|------|------|
| フレームワーク | Flutter 3.x | クロスプラットフォームUI |
| ゲームエンジン | Flame 1.34+ | 2Dゲーム描画・ゲームループ |
| 状態管理 | Riverpod 2.x | DI・状態管理 |
| ルーティング | go_router 14+ | 画面遷移 |
| ローカル保存 | SharedPreferences | 設定・ハイスコア永続化 |
| オーディオ | flame_audio | BGM・効果音再生 |
| テスト | flutter_test, flame_test | 単体・ウィジェットテスト |
| モノレポ管理 | Melos 7.x | 複数パッケージ管理 |
| 静的解析 | very_good_analysis | 厳格なlintルール |

## アーキテクチャ

**Clean Architecture + モノレポ（Dart Workspace）**

```
packages/
├── domain/          # Pure Dart - エンティティ、サービスインターフェース
├── application/     # ユースケース（Either<Failure, T>）
├── infrastructure/  # Repository/Service実装
└── presentation/    # Flutter/Flame UI

lib/
└── main.dart        # エントリーポイント
```

### レイヤー依存ルール

```
依存の方向: Presentation → Application → Domain ← Infrastructure

✅ 許可:
  - presentation → application → domain
  - infrastructure → domain
  - 全レイヤー → core/

❌ 禁止:
  - domain → presentation（逆方向）
  - domain → Flutter/Flame（フレームワーク依存）
  - application → infrastructure
```

検証: `flutter test test/architecture_test.dart`

## ゲーム仕様

### テトリスルール（標準ガイドライン準拠）

| 項目 | 仕様 |
|------|------|
| ボード | 10×20（+ バッファ4行） |
| テトリミノ | 7種類（I, O, T, S, Z, J, L） |
| 生成 | 7-bagアルゴリズム |
| 回転 | SRS（Super Rotation System）壁蹴り対応 |
| NEXT | 3個表示 |
| HOLD | 1ターン1回入れ替え可 |
| ゴースト | 落下予定位置を半透明表示 |
| ロックダウン | Extended Lock Down（0.5秒、最大15回リセット） |

### スコア計算

| アクション | 基本点 | 計算式 |
|------------|--------|--------|
| Single（1ライン） | 100 | 100 × Level |
| Double（2ライン） | 300 | 300 × Level |
| Triple（3ライン） | 500 | 500 × Level |
| Tetris（4ライン） | 800 | 800 × Level |
| ソフトドロップ | 1/マス | 落下距離 × 1 |
| ハードドロップ | 2/マス | 落下距離 × 2 |

### レベルシステム

- レベルアップ: 10ライン消去ごと
- 最大レベル: 15
- 落下速度: Level 1（1.0秒/マス）→ Level 15（0.1秒/マス）

### ゲームオーバー条件

新しいテトリミノがスポーン位置で衝突した場合

## 画面構成

| 画面 | ルート | 説明 |
|------|--------|------|
| タイトル | `/` | START, SETTINGS, HIGH SCORE |
| ゲーム | `/game` | メインプレイ画面（Flame描画） |
| ポーズ | - | ゲーム上にオーバーレイ（RESUME, QUIT） |
| ゲームオーバー | `/game-over` | スコア表示, RETRY, GO TITLE |
| 設定 | `/settings` | 各種設定項目 |

## 設定機能

| 項目 | 説明 |
|------|------|
| BGM音量 | 0〜100% スライダー |
| SE音量 | 0〜100% スライダー |
| ゴースト表示 | ON/OFF切り替え |
| 操作キー変更 | PC向けキーバインド設定 |
| 開始レベル | 1〜15から選択 |
| テーマ | ダーク/ライト/システム設定に従う |
| 言語 | 日本語/英語 |
| ハイスコアリセット | 確認ダイアログ付き |

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

画面下部に仮想ボタンを配置:
- ◀ ▶ : 左右移動
- ↺ ↻ : 左右回転
- ▼ : ソフトドロップ
- ⬇⬇ : ハードドロップ
- HOLD : ホールド

## UI/UXデザイン

### デザインテーマ

**レトロ/ピクセル風**
- ドットフォント使用（Press Start 2P等）
- シンプルな配色
- ゲームボーイ/ファミコン風の雰囲気

### テーマ対応

- ダークモード: 暗い背景、明るいブロック
- ライトモード: 明るい背景、鮮やかなブロック
- システム設定に連動

### レスポンシブ対応

- Web: 横長レイアウト（ボード中央、サイドパネル左右）
- モバイル: 縦長レイアウト（ボード上、コントロール下）
- タブレット: 適応レイアウト

## オーディオ

### BGM

- タイトル画面: タイトルBGM
- ゲーム中: メインBGM（ループ）
- ゲームオーバー: ゲームオーバーBGM

### 効果音（SE）

| タイミング | 効果音 |
|------------|--------|
| 移動 | move.wav |
| 回転 | rotate.wav |
| ハードドロップ | hard_drop.wav |
| ソフトドロップ着地 | soft_drop.wav |
| ライン消去（1-3） | line_clear.wav |
| Tetris（4ライン） | tetris.wav |
| レベルアップ | level_up.wav |
| ホールド | hold.wav |
| ゲームオーバー | game_over.wav |

## 多言語対応（i18n）

### 対応言語

- 日本語（ja）
- 英語（en）

### 実装方針

- flutter_localizations + ARBファイル
- システム言語自動検出
- 設定画面から手動切り替え可

## 開発ルール

### TDD（テスト駆動開発）

```
1. Red   - 失敗するテストを書く
2. Green - テストを通す最小限の実装
3. Refactor - コードを改善
```

### テストカバレッジ目標

| レイヤー | 目標 |
|----------|------|
| Domain | 95%+ |
| Application | 90%+ |
| Infrastructure | 80%+ |
| Presentation | 70%+ |

### イミュータブル設計

- Entity/ValueObjectは`@immutable`
- 状態変更は`copyWith`パターン
- freezedは使用しない（手動実装）

```dart
@immutable
class GameState {
  final Board board;
  final Tetromino? currentTetromino;
  
  GameState copyWith({Board? board, Tetromino? currentTetromino}) {
    return GameState(
      board: board ?? this.board,
      currentTetromino: currentTetromino ?? this.currentTetromino,
    );
  }
}
```

### UseCase設計

- 1クラス1責務
- `execute`メソッドを持つ
- 戻り値は`Either<Failure, T>`

```dart
class MoveTetrominoUseCase {
  Either<Failure, GameState> execute(GameState state, MoveDirection dir) {
    // ...
  }
}
```

### 命名規則

| 種類 | 規則 | 例 |
|------|------|-----|
| ファイル | snake_case | `game_state.dart` |
| クラス | PascalCase | `GameState` |
| 変数・関数 | camelCase | `currentTetromino` |
| 定数 | camelCase or SCREAMING_SNAKE | `maxLevel`, `MAX_LEVEL` |
| プライベート | _prefix | `_state` |
| Provider | xxxProvider | `gameControllerProvider` |

### Git運用

- mainブランチに直接コミット
- コミットメッセージは日本語OK
- 機能単位でコミット

## コマンド

### 開発

```bash
flutter run                          # 実行（デフォルトデバイス）
flutter run -d chrome                # Web実行
flutter run -d macos                 # macOS実行
flutter run -d ios                   # iOSシミュレータ
flutter run -d android               # Androidエミュレータ
```

### テスト

```bash
flutter test                         # 全テスト
flutter test test/architecture_test.dart  # アーキテクチャテスト
flutter test --coverage              # カバレッジ付き
```

### Melos

```bash
melos run test                       # 全パッケージテスト
melos run test:domain                # Domainパッケージのみ
melos run analyze                    # 静的解析
melos run format                     # フォーマット
melos run ci                         # CI（format + analyze + test）
```

### ビルド

```bash
flutter build web                    # Web
flutter build apk                    # Android
flutter build ios                    # iOS
flutter build macos                  # macOS
flutter build windows                # Windows
```

### 依存関係

```bash
flutter pub get                      # 依存取得
flutter pub outdated                 # 更新確認
melos run pub:upgrade                # 全パッケージ更新
```

## 実装優先順位

### Phase 1: コアゲーム

1. Domain層エンティティ（Tetromino, Board, GameState）
2. Domain層サービス（Collision, Rotation, LineClear, Scoring）
3. Application層ユースケース（Move, Rotate, HardDrop, GameTick）
4. ゲーム画面（Flameコンポーネント）

### Phase 2: 基本機能

5. タイトル画面
6. ゲームオーバー画面
7. ポーズ機能
8. ハイスコア保存

### Phase 3: 拡張機能

9. 設定画面・設定保存
10. オーディオ（BGM/SE）
11. 多言語対応
12. ダーク/ライトテーマ

### Phase 4: 仕上げ

13. レスポンシブ対応
14. アニメーション・エフェクト
15. パフォーマンス最適化
16. 各プラットフォームビルド・テスト

## 関連ドキュメント

| ドキュメント | 説明 |
|--------------|------|
| `DESIGN.md` | 基本設計書（インデックス） |
| `ARCHITECTURE.md` | アーキテクチャ詳細 |
| `docs/design/game.md` | ゲーム機能詳細設計 |
| `docs/design/title.md` | タイトル画面設計 |
| `docs/design/game_over.md` | ゲームオーバー画面設計 |
| `docs/design/settings.md` | 設定機能設計 |
| `docs/design/score.md` | スコア機能設計 |
| `docs/design/audio.md` | オーディオ機能設計 |
| `docs/design/appendix.md` | 付録（テトリミノ形状、SRS等） |

## 注意事項

- Domain層はPure Dart（Flutter/Flame依存禁止）
- コード生成ツール（freezed等）は使用しない
- 日本語コメントOK
- 設計ドキュメントは実装に合わせて更新
