# title - タイトル画面

[← 設計書トップ](../../DESIGN.md)

---

## ワイヤーフレーム

```
┌─────────────────────────────────────┐
│                                     │
│          ████████████████           │
│            FLAME TETRIS             │
│          ████████████████           │
│                                     │
│         ┌─────────────────┐         │
│         │    START GAME   │         │
│         └─────────────────┘         │
│         ┌─────────────────┐         │
│         │    SETTINGS     │         │
│         └─────────────────┘         │
│         ┌─────────────────┐         │
│         │    HIGH SCORE   │         │
│         └─────────────────┘         │
│                                     │
│              v1.0.0                 │
└─────────────────────────────────────┘
```

---

## 要素説明

| 要素 | 説明 |
|------|------|
| ロゴ | ゲームタイトル「FLAME TETRIS」 |
| START GAME | ゲーム画面へ遷移 |
| SETTINGS | 設定画面へ遷移 |
| HIGH SCORE | ハイスコアをダイアログ表示 |

---

## ディレクトリ構成

```
features/title/
└── presentation/
    ├── screens/
    │   └── title_screen.dart
    └── widgets/
        ├── title_logo.dart
        ├── menu_button.dart
        └── high_score_display.dart
```

---

## 実装

### TitleScreen

```dart
class TitleScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleLogo(),
            SizedBox(height: 48),
            MenuButton(label: 'START GAME', onPressed: () => context.go('/game')),
            MenuButton(label: 'SETTINGS', onPressed: () => context.go('/settings')),
            MenuButton(label: 'HIGH SCORE', onPressed: () => _showHighScoreDialog(context, ref)),
            Spacer(),
            Text('v1.0.0'),
          ],
        ),
      ),
    );
  }
}
```

### TitleLogo

```dart
class TitleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBlock(Colors.cyan),    // I
            _buildBlock(Colors.yellow),  // O
            _buildBlock(Colors.purple),  // T
            _buildBlock(Colors.green),   // S
          ],
        ),
        Text(
          'FLAME TETRIS',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
```

### MenuButton

```dart
class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
```
