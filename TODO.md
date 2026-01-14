# Flame Tetris - 実行計画（TODO）

> 最終更新: 2026-01-14 (Phase 2 完了)

## 概要

このドキュメントはFlame Tetrisの実装計画です。  
TDDで開発するため、各タスクは「テスト作成 → 実装」の順序で進めます。

---

## 凡例

- [ ] 未着手
- [x] 完了
- 🔴 Red（テスト作成）
- 🟢 Green（実装）
- 🔵 Refactor（リファクタリング）

---

## Phase 1: コアゲーム（MVP）

**目標**: 最低限遊べるテトリスを完成させる

### 1.1 Domain層 - Enums

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.1.1 | TetrominoType enum（I,O,T,S,Z,J,L + 色情報） | `packages/domain/lib/src/enums/tetromino_type.dart` | [x] |
| 1.1.2 | RotationState enum（0°,90°,180°,270°） | `packages/domain/lib/src/enums/rotation_state.dart` | [x] |
| 1.1.3 | MoveDirection enum（left, right, down） | `packages/domain/lib/src/enums/move_direction.dart` | [x] |
| 1.1.4 | RotationDirection enum（clockwise, counterClockwise） | `packages/domain/lib/src/enums/rotation_direction.dart` | [x] |
| 1.1.5 | GameStatus enum（ready, playing, paused, gameOver） | `packages/domain/lib/src/enums/game_status.dart` | [x] |
| 1.1.6 | enums.dart barrel更新 | `packages/domain/lib/src/enums/enums.dart` | [x] |

### 1.2 Domain層 - Entities

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.2.1 | 🔴 Position テスト作成 | `packages/domain/test/entities/position_test.dart` | [x] |
| 1.2.2 | 🟢 Position 実装（x, y座標、演算子） | `packages/domain/lib/src/entities/position.dart` | [x] |
| 1.2.3 | 🔴 Tetromino テスト作成 | `packages/domain/test/entities/tetromino_test.dart` | [x] |
| 1.2.4 | 🟢 Tetromino 実装（type, position, rotation, cells） | `packages/domain/lib/src/entities/tetromino.dart` | [x] |
| 1.2.5 | 🔴 Board テスト作成 | `packages/domain/test/entities/board_test.dart` | [x] |
| 1.2.6 | 🟢 Board 実装（grid, place, clearLines） | `packages/domain/lib/src/entities/board.dart` | [x] |
| 1.2.7 | 🔴 GameState テスト作成 | `packages/domain/test/entities/game_state_test.dart` | [x] |
| 1.2.8 | 🟢 GameState 実装（board, current, held, nextQueue, score, level, status） | `packages/domain/lib/src/entities/game_state.dart` | [x] |
| 1.2.9 | entities.dart barrel更新 | `packages/domain/lib/src/entities/entities.dart` | [x] |

### 1.3 Domain層 - Value Objects

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.3.1 | 🔴 Level テスト作成 | `packages/domain/test/value_objects/level_test.dart` | [x] |
| 1.3.2 | 🟢 Level 実装（1-15、速度計算） | `packages/domain/lib/src/value_objects/level.dart` | [x] |
| 1.3.3 | 🔴 LinesCleared テスト作成 | `packages/domain/test/value_objects/lines_cleared_test.dart` | [x] |
| 1.3.4 | 🟢 LinesCleared 実装（0-4、レベルアップ判定） | `packages/domain/lib/src/value_objects/lines_cleared.dart` | [x] |
| 1.3.5 | value_objects.dart barrel更新 | `packages/domain/lib/src/value_objects/value_objects.dart` | [x] |

### 1.4 Domain層 - テトリミノ形状データ

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.4.1 | TetrominoShapes 定数（全7種×4回転状態の座標） | `packages/domain/lib/src/constants/tetromino_shapes.dart` | [x] |
| 1.4.2 | SRSKickData 定数（壁蹴りテーブル） | `packages/domain/lib/src/constants/srs_kick_data.dart` | [x] |

### 1.5 Domain層 - Services（インターフェース）

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.5.1 | CollisionService interface | `packages/domain/lib/src/services/collision_service.dart` | [x] |
| 1.5.2 | RotationService interface | `packages/domain/lib/src/services/rotation_service.dart` | [x] |
| 1.5.3 | LineClearService interface | `packages/domain/lib/src/services/line_clear_service.dart` | [x] |
| 1.5.4 | ScoringService interface | `packages/domain/lib/src/services/scoring_service.dart` | [x] |
| 1.5.5 | services.dart barrel更新 | `packages/domain/lib/src/services/services.dart` | [x] |

### 1.6 Domain層 - Failures

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.6.1 | Failure 基底クラス | `packages/domain/lib/src/failures/failure.dart` | [x] |
| 1.6.2 | GameFailure（CollisionFailure, InvalidMoveFailure等） | `packages/domain/lib/src/failures/game_failure.dart` | [x] |
| 1.6.3 | failures.dart barrel更新 | `packages/domain/lib/src/failures/failures.dart` | [x] |

### 1.7 Infrastructure層 - Services実装

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.7.1 | 🔴 CollisionServiceImpl テスト | `packages/infrastructure/test/services/collision_service_impl_test.dart` | [x] |
| 1.7.2 | 🟢 CollisionServiceImpl 実装 | `packages/infrastructure/lib/src/services/collision_service_impl.dart` | [x] |
| 1.7.3 | 🔴 RotationServiceImpl テスト（SRS壁蹴り含む） | `packages/infrastructure/test/services/rotation_service_impl_test.dart` | [x] |
| 1.7.4 | 🟢 RotationServiceImpl 実装 | `packages/infrastructure/lib/src/services/rotation_service_impl.dart` | [x] |
| 1.7.5 | 🔴 LineClearServiceImpl テスト | `packages/infrastructure/test/services/line_clear_service_impl_test.dart` | [x] |
| 1.7.6 | 🟢 LineClearServiceImpl 実装 | `packages/infrastructure/lib/src/services/line_clear_service_impl.dart` | [x] |
| 1.7.7 | 🔴 ScoringServiceImpl テスト | `packages/infrastructure/test/services/scoring_service_impl_test.dart` | [x] |
| 1.7.8 | 🟢 ScoringServiceImpl 実装 | `packages/infrastructure/lib/src/services/scoring_service_impl.dart` | [x] |
| 1.7.9 | services.dart barrel更新 | `packages/infrastructure/lib/src/services/services.dart` | [x] |

### 1.8 Application層 - Services

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.8.1 | 🔴 TetrominoGenerator テスト（7-bag） | `packages/application/test/services/tetromino_generator_test.dart` | [x] |
| 1.8.2 | 🟢 TetrominoGenerator 実装 | `packages/application/lib/src/services/tetromino_generator.dart` | [x] |
| 1.8.3 | services.dart barrel更新 | `packages/application/lib/src/services/services.dart` | [x] |

### 1.9 Application層 - UseCases

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.9.1 | 🔴 StartGameUseCase テスト | `packages/application/test/usecases/start_game_usecase_test.dart` | [x] |
| 1.9.2 | 🟢 StartGameUseCase 実装 | `packages/application/lib/src/usecases/start_game_usecase.dart` | [x] |
| 1.9.3 | 🔴 MoveTetrominoUseCase テスト | `packages/application/test/usecases/move_tetromino_usecase_test.dart` | [x] |
| 1.9.4 | 🟢 MoveTetrominoUseCase 実装 | `packages/application/lib/src/usecases/move_tetromino_usecase.dart` | [x] |
| 1.9.5 | 🔴 RotateTetrominoUseCase テスト | `packages/application/test/usecases/rotate_tetromino_usecase_test.dart` | [x] |
| 1.9.6 | 🟢 RotateTetrominoUseCase 実装 | `packages/application/lib/src/usecases/rotate_tetromino_usecase.dart` | [x] |
| 1.9.7 | 🔴 SoftDropUseCase テスト | `packages/application/test/usecases/soft_drop_usecase_test.dart` | [x] |
| 1.9.8 | 🟢 SoftDropUseCase 実装 | `packages/application/lib/src/usecases/soft_drop_usecase.dart` | [x] |
| 1.9.9 | 🔴 HardDropUseCase テスト | `packages/application/test/usecases/hard_drop_usecase_test.dart` | [x] |
| 1.9.10 | 🟢 HardDropUseCase 実装 | `packages/application/lib/src/usecases/hard_drop_usecase.dart` | [x] |
| 1.9.11 | 🔴 HoldTetrominoUseCase テスト | `packages/application/test/usecases/hold_tetromino_usecase_test.dart` | [x] |
| 1.9.12 | 🟢 HoldTetrominoUseCase 実装 | `packages/application/lib/src/usecases/hold_tetromino_usecase.dart` | [x] |
| 1.9.13 | 🔴 GameTickUseCase テスト（自動落下+着地処理） | `packages/application/test/usecases/game_tick_usecase_test.dart` | [x] |
| 1.9.14 | 🟢 GameTickUseCase 実装 | `packages/application/lib/src/usecases/game_tick_usecase.dart` | [x] |
| 1.9.15 | 🔴 PauseGameUseCase テスト | `packages/application/test/usecases/pause_game_usecase_test.dart` | [x] |
| 1.9.16 | 🟢 PauseGameUseCase 実装 | `packages/application/lib/src/usecases/pause_game_usecase.dart` | [x] |
| 1.9.17 | usecases.dart barrel更新 | `packages/application/lib/src/usecases/usecases.dart` | [x] |

### 1.10 Presentation層 - GameController

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.10.1 | 🔴 GameController テスト | `packages/presentation/test/controllers/game_controller_test.dart` | [x] |
| 1.10.2 | 🟢 GameController 実装（ChangeNotifier） | `packages/presentation/lib/src/controllers/game_controller.dart` | [x] |
| 1.10.3 | controllers.dart barrel更新 | `packages/presentation/lib/src/controllers/controllers.dart` | [x] |

### 1.11 Presentation層 - Flameコンポーネント

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.11.1 | TetrisGame（FlameGame本体） | `packages/presentation/lib/src/flame/tetris_game.dart` | [x] |
| 1.11.2 | BoardComponent（ボード描画） | `packages/presentation/lib/src/flame/components/board_component.dart` | [x] |
| 1.11.3 | TetrominoComponent（テトリミノ描画） | `packages/presentation/lib/src/flame/components/tetromino_component.dart` | [x] |
| 1.11.4 | GhostComponent（ゴーストピース描画） | `packages/presentation/lib/src/flame/components/ghost_component.dart` | [x] |
| 1.11.5 | BlockComponent（個別ブロック描画） | `packages/presentation/lib/src/flame/components/block_component.dart` | [x] |
| 1.11.6 | flame.dart barrel更新 | `packages/presentation/lib/src/flame/flame.dart` | [x] |

### 1.12 Presentation層 - ゲーム画面

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.12.1 | GameScreen（メイン画面レイアウト） | `packages/presentation/lib/src/screens/game_screen.dart` | [x] |
| 1.12.2 | ScorePanel（スコア・レベル表示） | `packages/presentation/lib/src/widgets/score_panel.dart` | [x] |
| 1.12.3 | NextPanel（NEXT表示） | `packages/presentation/lib/src/widgets/next_panel.dart` | [x] |
| 1.12.4 | HoldPanel（HOLD表示） | `packages/presentation/lib/src/widgets/hold_panel.dart` | [x] |
| 1.12.5 | screens.dart barrel更新 | `packages/presentation/lib/src/screens/screens.dart` | [x] |
| 1.12.6 | widgets.dart barrel更新 | `packages/presentation/lib/src/widgets/widgets.dart` | [x] |

### 1.13 Presentation層 - Providers

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.13.1 | gameControllerProvider | `packages/presentation/lib/src/providers/game_provider.dart` | [x] |
| 1.13.2 | providers.dart barrel更新 | `packages/presentation/lib/src/providers/providers.dart` | [x] |

### 1.14 Presentation層 - 入力処理

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.14.1 | KeyboardHandler（キーボード入力） | `packages/presentation/lib/src/flame/input/keyboard_handler.dart` | [x] |
| 1.14.2 | MobileControls（モバイル操作ボタン） | `packages/presentation/lib/src/widgets/mobile_controls.dart` | [x] |

### 1.15 統合

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 1.15.1 | main.dart更新（GameScreen表示） | `lib/main.dart` | [x] |
| 1.15.2 | Phase 1 動作確認（Web） | - | [x] |
| 1.15.3 | Phase 1 動作確認（モバイル） | - | [x] |

---

## Phase 2: 基本機能

**目標**: タイトル画面、ゲームオーバー、ポーズ、ハイスコアを実装

### 2.1 Domain層 - Score

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 2.1.1 | 🔴 HighScore テスト | `packages/domain/test/entities/high_score_test.dart` | [x] |
| 2.1.2 | 🟢 HighScore 実装 | `packages/domain/lib/src/entities/high_score.dart` | [x] |
| 2.1.3 | ScoreRepository interface | `packages/domain/lib/src/repositories/score_repository.dart` | [x] |

### 2.2 Infrastructure層 - Repository

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 2.2.1 | 🔴 ScoreRepositoryImpl テスト | `packages/infrastructure/test/repositories/score_repository_impl_test.dart` | [x] |
| 2.2.2 | 🟢 ScoreRepositoryImpl 実装（SharedPreferences） | `packages/infrastructure/lib/src/repositories/score_repository_impl.dart` | [x] |

### 2.3 Application層 - Score UseCases

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 2.3.1 | 🔴 GetHighScoreUseCase テスト | `packages/application/test/usecases/get_high_score_usecase_test.dart` | [x] |
| 2.3.2 | 🟢 GetHighScoreUseCase 実装 | `packages/application/lib/src/usecases/get_high_score_usecase.dart` | [x] |
| 2.3.3 | 🔴 SaveHighScoreUseCase テスト | `packages/application/test/usecases/save_high_score_usecase_test.dart` | [x] |
| 2.3.4 | 🟢 SaveHighScoreUseCase 実装 | `packages/application/lib/src/usecases/save_high_score_usecase.dart` | [x] |

### 2.4 Presentation層 - Router

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 2.4.1 | AppRouter（go_router設定） | `packages/presentation/lib/src/router/app_router.dart` | [x] |
| 2.4.2 | router.dart barrel更新 | `packages/presentation/lib/src/router/router.dart` | [x] |

### 2.5 Presentation層 - 画面

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 2.5.1 | TitleScreen（START, SETTINGS, HIGH SCORE） | `packages/presentation/lib/src/screens/title_screen.dart` | [x] |
| 2.5.2 | GameOverScreen（スコア表示, RETRY, GO TITLE） | `packages/presentation/lib/src/screens/game_over_screen.dart` | [x] |
| 2.5.3 | PauseOverlay（RESUME, QUIT） | `packages/presentation/lib/src/widgets/pause_overlay.dart` | [x] |
| 2.5.4 | HighScoreDialog（ハイスコア表示） | `packages/presentation/lib/src/widgets/high_score_dialog.dart` | [x] |

### 2.6 統合

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 2.6.1 | main.dart更新（Router適用） | `lib/main.dart` | [x] |
| 2.6.2 | Phase 2 動作確認 | - | [x] |

---

## Phase 3: 拡張機能

**目標**: 設定、オーディオ、多言語、テーマ対応

### 3.1 Domain層 - Settings

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.1.1 | 🔴 GameSettings テスト | `packages/domain/test/entities/game_settings_test.dart` | [ ] |
| 3.1.2 | 🟢 GameSettings 実装 | `packages/domain/lib/src/entities/game_settings.dart` | [ ] |
| 3.1.3 | 🔴 KeyBindings テスト | `packages/domain/test/entities/key_bindings_test.dart` | [ ] |
| 3.1.4 | 🟢 KeyBindings 実装 | `packages/domain/lib/src/entities/key_bindings.dart` | [ ] |
| 3.1.5 | SettingsRepository interface | `packages/domain/lib/src/repositories/settings_repository.dart` | [ ] |
| 3.1.6 | AudioService interface | `packages/domain/lib/src/services/audio_service.dart` | [ ] |

### 3.2 Infrastructure層 - Settings & Audio

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.2.1 | 🔴 SettingsRepositoryImpl テスト | `packages/infrastructure/test/repositories/settings_repository_impl_test.dart` | [ ] |
| 3.2.2 | 🟢 SettingsRepositoryImpl 実装 | `packages/infrastructure/lib/src/repositories/settings_repository_impl.dart` | [ ] |
| 3.2.3 | 🔴 AudioServiceImpl テスト | `packages/infrastructure/test/services/audio_service_impl_test.dart` | [ ] |
| 3.2.4 | 🟢 AudioServiceImpl 実装（flame_audio） | `packages/infrastructure/lib/src/services/audio_service_impl.dart` | [ ] |

### 3.3 Application層 - Settings UseCases

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.3.1 | 🔴 GetSettingsUseCase テスト | `packages/application/test/usecases/get_settings_usecase_test.dart` | [ ] |
| 3.3.2 | 🟢 GetSettingsUseCase 実装 | `packages/application/lib/src/usecases/get_settings_usecase.dart` | [ ] |
| 3.3.3 | 🔴 SaveSettingsUseCase テスト | `packages/application/test/usecases/save_settings_usecase_test.dart` | [ ] |
| 3.3.4 | 🟢 SaveSettingsUseCase 実装 | `packages/application/lib/src/usecases/save_settings_usecase.dart` | [ ] |

### 3.4 Presentation層 - 設定画面

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.4.1 | SettingsScreen（設定画面本体） | `packages/presentation/lib/src/screens/settings_screen.dart` | [ ] |
| 3.4.2 | VolumeSlider（音量スライダー） | `packages/presentation/lib/src/widgets/volume_slider.dart` | [ ] |
| 3.4.3 | KeyBindingEditor（キー設定） | `packages/presentation/lib/src/widgets/key_binding_editor.dart` | [ ] |
| 3.4.4 | settingsProvider | `packages/presentation/lib/src/providers/settings_provider.dart` | [ ] |

### 3.5 オーディオ

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.5.1 | BGMファイル配置（assets/audio/bgm/） | - | [ ] |
| 3.5.2 | SEファイル配置（assets/audio/se/） | - | [ ] |
| 3.5.3 | AudioController | `packages/presentation/lib/src/controllers/audio_controller.dart` | [ ] |
| 3.5.4 | audioProvider | `packages/presentation/lib/src/providers/audio_provider.dart` | [ ] |

### 3.6 多言語対応（i18n）

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.6.1 | l10n.yaml設定 | `l10n.yaml` | [ ] |
| 3.6.2 | app_en.arb（英語） | `lib/l10n/app_en.arb` | [ ] |
| 3.6.3 | app_ja.arb（日本語） | `lib/l10n/app_ja.arb` | [ ] |
| 3.6.4 | 各画面にローカライズ適用 | - | [ ] |

### 3.7 テーマ対応

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.7.1 | AppTheme（ダーク/ライト定義） | `packages/presentation/lib/src/theme/app_theme.dart` | [ ] |
| 3.7.2 | PixelFont設定（Press Start 2P等） | - | [ ] |
| 3.7.3 | themeProvider | `packages/presentation/lib/src/providers/theme_provider.dart` | [ ] |

### 3.8 統合

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 3.8.1 | Phase 3 動作確認 | - | [ ] |

---

## Phase 4: 仕上げ

**目標**: レスポンシブ対応、アニメーション、最適化、各プラットフォームビルド

### 4.1 レスポンシブ対応

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 4.1.1 | ResponsiveLayout（画面サイズ判定） | `packages/presentation/lib/src/widgets/responsive_layout.dart` | [ ] |
| 4.1.2 | GameScreen レスポンシブ対応 | - | [ ] |
| 4.1.3 | TitleScreen レスポンシブ対応 | - | [ ] |

### 4.2 アニメーション・エフェクト

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 4.2.1 | ライン消去アニメーション | - | [ ] |
| 4.2.2 | Tetrisアニメーション（4ライン消去） | - | [ ] |
| 4.2.3 | レベルアップエフェクト | - | [ ] |
| 4.2.4 | ゲームオーバーアニメーション | - | [ ] |

### 4.3 パフォーマンス最適化

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 4.3.1 | Flameコンポーネント最適化 | - | [ ] |
| 4.3.2 | 不要な再描画の削減 | - | [ ] |
| 4.3.3 | メモリ使用量確認 | - | [ ] |

### 4.4 テスト拡充

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 4.4.1 | アーキテクチャテスト | `test/architecture_test.dart` | [ ] |
| 4.4.2 | 統合テスト | `test/integration/` | [ ] |
| 4.4.3 | カバレッジ確認（Domain 95%+, Application 90%+） | - | [ ] |

### 4.5 各プラットフォームビルド

| # | タスク | 状態 |
|---|--------|------|
| 4.5.1 | Web ビルド・動作確認 | [ ] |
| 4.5.2 | iOS ビルド・動作確認 | [ ] |
| 4.5.3 | Android ビルド・動作確認 | [ ] |
| 4.5.4 | macOS ビルド・動作確認 | [ ] |
| 4.5.5 | Windows ビルド・動作確認 | [ ] |

### 4.6 ドキュメント更新

| # | タスク | ファイル | 状態 |
|---|--------|----------|------|
| 4.6.1 | README.md更新 | `README.md` | [ ] |
| 4.6.2 | 設計ドキュメント最終更新 | `docs/design/*.md` | [ ] |
| 4.6.3 | スクリーンショット追加 | - | [ ] |

---

## 進捗サマリー

| Phase | タスク数 | 完了 | 進捗率 |
|-------|----------|------|--------|
| Phase 1: コアゲーム | 60 | 60 | 100% |
| Phase 2: 基本機能 | 14 | 14 | 100% |
| Phase 3: 拡張機能 | 22 | 0 | 0% |
| Phase 4: 仕上げ | 17 | 0 | 0% |
| **合計** | **113** | **74** | **65%** |

---

## 次のアクション

1. [x] ~~Phase 1 完了（コアゲーム）~~
2. [x] ~~Phase 2 完了（基本機能）~~
3. [ ] Phase 3.1 から開始（GameSettings Entity）
4. [ ] 設定画面・オーディオ機能の実装

---

## 備考

- 各タスクは独立して完了可能なサイズに分割済み
- TDDサイクル：🔴（テスト作成）→ 🟢（実装）→ 🔵（リファクタ）
- テストファイルは本体実装の前に作成する
- barrelファイル（xxx.dart）はそのセクション完了時に更新
