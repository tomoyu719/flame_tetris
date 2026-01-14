# game_over - ゲームオーバー画面

[← 設計書トップ](../../DESIGN.md)

---

## ワイヤーフレーム

```
┌─────────────────────────────────────┐
│                                     │
│          ┌─────────────────┐        │
│          │   GAME OVER     │        │
│          └─────────────────┘        │
│                                     │
│          ┌─────────────────┐        │
│          │    YOUR SCORE   │        │
│          │     12,450      │        │
│          └─────────────────┘        │
│                                     │
│          ┌─────────────────┐        │
│          │   HIGH SCORE    │        │
│          │     25,800      │        │
│          │   ★ NEW BEST!   │ ← 更新時のみ
│          └─────────────────┘        │
│                                     │
│          ┌─────────────────┐        │
│          │     RETRY       │        │
│          └─────────────────┘        │
│          ┌─────────────────┐        │
│          │    GO TITLE     │        │
│          └─────────────────┘        │
│                                     │
└─────────────────────────────────────┘
```

---

## 要素説明

| 要素 | 説明 |
|------|------|
| YOUR SCORE | 今回のスコア |
| HIGH SCORE | ハイスコア（新記録時は「★ NEW BEST!」表示） |
| RETRY | 新しいゲームを開始 |
| GO TITLE | タイトル画面に戻る |

---

## ディレクトリ構成

```
features/game_over/
└── presentation/
    ├── screens/
    │   └── game_over_screen.dart
    └── widgets/
        ├── score_display.dart
        └── new_record_badge.dart
```

---

## 実装

### GameOverScreen

```dart
class GameOverScreen extends ConsumerWidget {
  final int finalScore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScore = ref.watch(highScoreProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('GAME OVER', style: TextStyle(fontSize: 36)),
            ScoreDisplay(label: 'YOUR SCORE', score: finalScore),
            ScoreDisplay(label: 'HIGH SCORE', score: highScore.score),
            if (finalScore > highScore.score) NewRecordBadge(),
            MenuButton(label: 'RETRY', onPressed: () => context.go('/game')),
            MenuButton(label: 'GO TITLE', onPressed: () => context.go('/')),
          ],
        ),
      ),
    );
  }
}
```

### ScoreDisplay

```dart
class ScoreDisplay extends StatelessWidget {
  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 14)),
          Text(
            NumberFormat('#,###').format(score),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
```

### NewRecordBadge

```dart
class NewRecordBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white),
          SizedBox(width: 8),
          Text('NEW BEST!', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
```
