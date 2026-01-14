# Lint警告解消プラン

> 作成日: 2026-01-14
> 対象: Flame Tetris プロジェクト
> Lintルール: very_good_analysis ^10.0.0

## 概要

| 項目 | 内容 |
|------|------|
| 総警告数 | 279件（全てinfoレベル） |
| 対象パッケージ | domain(106), presentation(99), application(46), infrastructure(28) |
| 推定作業時間 | 2-3時間 |

### 警告分布

```
tetris_domain        ████████████████████ 106件 (38%)
tetris_presentation  ██████████████████   99件 (35%)
tetris_application   █████████            46件 (16%)
tetris_infrastructure ██████              28件 (10%)
```

---

## 警告カテゴリ別分析

### Top 10 警告ルール

| # | ルール | 件数 | カテゴリ |
|---|--------|------|----------|
| 1 | `always_use_package_imports` | 59 | インポートスタイル |
| 2 | `avoid_redundant_argument_values` | 34 | コード品質 |
| 3 | `prefer_const_constructors` | 29 | パフォーマンス |
| 4 | `lines_longer_than_80_chars` | 29 | スタイル |
| 5 | `discarded_futures` | 25 | 非同期処理 |
| 6 | `public_member_api_docs` | 24 | ドキュメント |
| 7 | `cascade_invocations` | 16 | コードスタイル |
| 8 | `prefer_int_literals` | 11 | 型安全性 |
| 9 | `prefer_const_literals_to_create_immutables` | 10 | パフォーマンス |
| 10 | `avoid_catches_without_on_clauses` | 9 | エラー処理 |

---

## Phase 1: インポートスタイル修正（59件）

### 対象ルール
- `always_use_package_imports`

### 修正方針
相対インポートを `package:` 形式に変換する。

```dart
// Before
import '../entities/position.dart';

// After
import 'package:tetris_domain/src/entities/position.dart';
```

### 対象ファイル

#### Domain パッケージ (20件)
- `lib/src/constants/srs_kick_data.dart` (2)
- `lib/src/constants/tetromino_shapes.dart` (2)
- `lib/src/entities/board.dart` (2)
- `lib/src/entities/game_state.dart` (3)
- `lib/src/entities/tetromino.dart` (2)
- `lib/src/failures/game_failure.dart` (1)
- `lib/src/repositories/score_repository.dart` (1)
- `lib/src/services/collision_service.dart` (2)
- `lib/src/services/line_clear_service.dart` (2)
- `lib/src/services/rotation_service.dart` (2)
- `lib/src/services/scoring_service.dart` (1)

#### Application パッケージ (10件)
- `lib/src/game_controller.dart` (2)
- `lib/src/usecases/game_tick_usecase.dart` (1)
- `lib/src/usecases/hard_drop_usecase.dart` (1)
- `lib/src/usecases/hold_tetromino_usecase.dart` (1)
- `lib/src/usecases/move_tetromino_usecase.dart` (1)
- `lib/src/usecases/pause_game_usecase.dart` (1)
- `lib/src/usecases/rotate_tetromino_usecase.dart` (1)
- `lib/src/usecases/soft_drop_usecase.dart` (1)

#### Presentation パッケージ (29件)
- `lib/src/flame/components/board_component.dart` (3)
- `lib/src/flame/components/tetromino_component.dart` (1)
- `lib/src/flame/tetris_game.dart` (1)
- `lib/src/providers/theme_provider.dart` (1)
- `lib/src/router/app_router.dart` (1)
- `lib/src/screens/game_over_screen.dart` (2)
- `lib/src/screens/game_screen.dart` (6)
- `lib/src/screens/settings_screen.dart` (6)
- `lib/src/screens/title_screen.dart` (4)
- `lib/src/widgets/high_score_dialog.dart` (1)
- `lib/src/widgets/hold_panel.dart` (1)
- `lib/src/widgets/next_panel.dart` (1)
- `lib/src/widgets/pause_overlay.dart` (2)

---

## Phase 2: const関連修正（40件）

### 対象ルール
- `prefer_const_constructors` (29件)
- `prefer_const_literals_to_create_immutables` (10件)
- `prefer_const_declarations` (1件)

### 修正方針

#### パターン1: コンストラクタに const を追加
```dart
// Before
Position(0, 0)

// After
const Position(0, 0)
```

#### パターン2: リストリテラルに const を追加
```dart
// Before
final list = [item1, item2];

// After
const list = [item1, item2];
```

### 主要対象ファイル
- `domain/lib/src/constants/srs_kick_data.dart` (16件)
- `presentation/lib/src/widgets/responsive_layout.dart` (9件)
- テストファイル各種 (15件)

---

## Phase 3: 非同期処理修正（25件）

### 対象ルール
- `discarded_futures`

### 修正方針

#### 方針A: unawaited() でラップ（Fire-and-forget）
オーディオ再生など、結果を待つ必要がない処理に使用。

```dart
import 'dart:async';

// Before
audioService.playSound();

// After
unawaited(audioService.playSound());
```

#### 方針B: async/await に変換
結果を待つべき処理に使用。

```dart
// Before
void onTap() {
  saveData();
}

// After
Future<void> onTap() async {
  await saveData();
}
```

### 対象ファイルと推奨方針

| ファイル | 件数 | 方針 |
|----------|------|------|
| `infrastructure/services/audio_service_impl.dart` | 11 | A |
| `presentation/screens/settings_screen.dart` | 6 | B |
| `presentation/flame/components/board_component.dart` | 5 | A |
| `presentation/flame/components/tetromino_component.dart` | 2 | A |
| `presentation/screens/title_screen.dart` | 1 | A |

---

## Phase 4: ドキュメント追加（24件）

### 対象ルール
- `public_member_api_docs`

### 修正方針
公開クラス・メンバーに doc comment を追加する。

```dart
// Before
class CollisionFailure extends GameFailure { ... }

// After
/// ブロックの衝突検出に失敗した場合のエラー
class CollisionFailure extends GameFailure { ... }
```

### 対象ファイル
- `domain/lib/src/failures/failure.dart` (1)
- `domain/lib/src/failures/game_failure.dart` (6)
- `domain/lib/src/services/line_clear_service.dart` (2)
- `domain/lib/src/services/rotation_service.dart` (2)
- `application/lib/src/usecases/game_tick_usecase.dart` (1)
- `application/lib/src/usecases/hard_drop_usecase.dart` (1)
- `presentation/lib/src/theme/app_theme.dart` (13)

---

## Phase 5: 行長修正（29件）

### 対象ルール
- `lines_longer_than_80_chars`

### 修正方針
80文字を超える行を適切に分割する。

```dart
// Before
expect(result, equals(SomeClass.method(param1, param2)));

// After
expect(
  result,
  equals(SomeClass.method(param1, param2)),
);
```

### 対象ファイル（主にテストファイル）
- `domain/test/entities/board_test.dart` (2)
- `domain/test/services/collision_service_test.dart` (6)
- `domain/test/services/line_clear_service_test.dart` (4)
- `application/test/usecases/game_tick_usecase_test.dart` (5)
- その他テストファイル (12)

---

## Phase 6: コードスタイル修正（52件）

### 6-1. cascade_invocations (16件)
```dart
// Before
list.add(item1);
list.add(item2);

// After
list
  ..add(item1)
  ..add(item2);
```

### 6-2. avoid_redundant_argument_values (34件)
デフォルト値と同じ引数を削除する。

```dart
// Before（false がデフォルト値の場合）
MyClass(isEnabled: false)

// After
MyClass()
```

### 6-3. その他
| ルール | 件数 | 修正内容 |
|--------|------|----------|
| `sort_constructors_first` | 4 | コンストラクタを先頭に移動 |
| `eol_at_end_of_file` | 4 | ファイル末尾に改行追加 |
| `omit_local_variable_types` | 3 | 明示的型宣言を削除 |
| `directives_ordering` | 3 | import文の順序修正 |
| `unnecessary_lambdas` | 2 | ラムダをtearoffに変換 |
| `unnecessary_import` | 2 | 不要なimportを削除 |
| `use_colored_box` | 2 | ContainerをColoredBoxに変更 |
| `use_setters_to_change_properties` | 2 | メソッドをsetterに変換 |
| `avoid_positional_boolean_parameters` | 2 | 名前付きパラメータに変更 |
| `prefer_int_literals` | 11 | `1.0` → `1` |

---

## Phase 7: 設計関連修正（15件）

### 7-1. @immutable アノテーション追加 (6件)
equals/hashCode をオーバーライドしているクラスに `@immutable` を追加。

```dart
// Before
class KickData {
  @override
  bool operator ==(Object other) { ... }
}

// After
@immutable
class KickData {
  const KickData(...);

  @override
  bool operator ==(Object other) { ... }
}
```

対象ファイル:
- `domain/lib/src/constants/srs_kick_data.dart` (2)
- `domain/lib/src/value_objects/level.dart` (2)
- `domain/lib/src/value_objects/lines_cleared.dart` (2)

### 7-2. 具体的な例外型の指定 (9件)
汎用 catch を具体的な例外型に変更。

```dart
// Before
try { ... } catch (e) { ... }

// After
try { ... } on Exception catch (e) { ... }
```

対象ファイル:
- `infrastructure/repositories/score_repository_impl.dart` (3)
- `infrastructure/repositories/settings_repository_impl.dart` (5)
- `presentation/providers/settings_provider.dart` (1)

---

## 実行順序

```
Phase 1 (59件) インポート修正
    ↓
Phase 2 (40件) const追加
    ↓
Phase 3 (25件) 非同期処理
    ↓
Phase 4 (24件) ドキュメント
    ↓
Phase 5 (29件) 行長修正
    ↓
Phase 6 (52件) スタイル修正
    ↓
Phase 7 (15件) 設計修正
```

---

## 検証コマンド

### 各Phase終了後
```bash
melos run analyze
```

### 全修正完了後
```bash
# 静的解析（警告0件を確認）
melos run analyze
melos run analyze:strict

# フォーマット確認
melos run format:check

# テスト実行
melos run test

# ビルド確認
flutter build web
```

---

## 今後のコーディング規約

### 推奨事項

1. **インポート**: 常に `package:` 形式を使用
2. **const**: 可能な限り const を使用
3. **非同期**: Fire-and-forget は `unawaited()` で明示
4. **ドキュメント**: 公開APIには必ず doc comment を記述
5. **行長**: 80文字以内に収める

### IDE設定

VSCodeの場合、`.vscode/settings.json` に以下を追加:

```json
{
  "editor.rulers": [80],
  "dart.lineLength": 80
}
```

---

## 参考: very_good_analysis について

`very_good_analysis` は Very Good Ventures が提供する厳格な Dart/Flutter 用 lint ルールセット。

- GitHub: https://github.com/VeryGoodOpenSource/very_good_analysis
- 特徴: 業界標準のベストプラクティスを強制
- 採用プロジェクト: Flutter公式サンプル、多数のOSSプロジェクト
