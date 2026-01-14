# Flame Tetris

Flutter + Flame で作成したテトリスゲームです。Clean Architecture を採用し、マルチプラットフォーム（Web, iOS, Android, macOS, Windows）に対応しています。

## 特徴

- **標準ガイドライン準拠**: SRS（Super Rotation System）壁蹴り、7-bagアルゴリズム、Extended Lock Down
- **マルチプラットフォーム**: Web, iOS, Android, macOS, Windows
- **レスポンシブデザイン**: モバイル・タブレット・デスクトップに最適化
- **多言語対応**: 日本語・英語
- **テーマ対応**: ダークモード・ライトモード・システム設定連動
- **Clean Architecture**: Domain / Application / Infrastructure / Presentation の4層構造

## ゲーム仕様

| 項目 | 仕様 |
|------|------|
| ボードサイズ | 10×20 |
| テトリミノ | 7種類（I, O, T, S, Z, J, L） |
| NEXT表示 | 3個 |
| HOLD | あり（1ターン1回） |
| ゴースト | あり |
| レベル | 1〜15（10ライン消去でレベルアップ） |

## 操作方法

### キーボード（PC）

| キー | 操作 |
|------|------|
| ← → | 左右移動 |
| ↓ | ソフトドロップ |
| ↑ / X | 右回転 |
| Z | 左回転 |
| Space | ハードドロップ |
| C | ホールド |
| Esc / P | ポーズ |

### モバイル

画面下部の仮想ボタンで操作します。

## セットアップ

### 必要条件

- Flutter 3.x
- Dart 3.x

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/yourusername/flame_tetris.git
cd flame_tetris

# 依存関係を取得
flutter pub get

# 実行
flutter run
```

### プラットフォーム別ビルド

```bash
# Web
flutter build web

# iOS
flutter build ios

# Android
flutter build apk

# macOS
flutter build macos

# Windows
flutter build windows
```

## プロジェクト構造

```
flame_tetris/
├── lib/
│   └── main.dart              # エントリーポイント
├── packages/
│   ├── domain/                # ドメイン層（エンティティ、サービスインターフェース）
│   ├── application/           # アプリケーション層（ユースケース）
│   ├── infrastructure/        # インフラ層（リポジトリ・サービス実装）
│   └── presentation/          # プレゼンテーション層（Flutter/Flame UI）
├── assets/
│   └── audio/                 # BGM・効果音
└── docs/
    └── design/                # 設計ドキュメント
```

## 技術スタック

| 分類 | 技術 |
|------|------|
| フレームワーク | Flutter 3.x |
| ゲームエンジン | Flame 1.34+ |
| 状態管理 | Riverpod 2.x |
| ルーティング | go_router 14+ |
| ローカル保存 | SharedPreferences |
| オーディオ | flame_audio |
| 静的解析 | very_good_analysis |

## スコア計算

| アクション | 得点 |
|------------|------|
| Single（1ライン） | 100 × Level |
| Double（2ライン） | 300 × Level |
| Triple（3ライン） | 500 × Level |
| Tetris（4ライン） | 800 × Level |
| ソフトドロップ | 1 × 落下マス数 |
| ハードドロップ | 2 × 落下マス数 |

## 開発

### テスト実行

```bash
# 全テスト
flutter test

# カバレッジ付き
flutter test --coverage
```

### Melosコマンド

```bash
# 全パッケージテスト
melos run test

# 静的解析
melos run analyze

# フォーマット
melos run format
```

## ライセンス

MIT License

## 作者

Created with Flutter + Flame
