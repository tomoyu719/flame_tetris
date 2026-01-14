# score - スコア機能

[← 設計書トップ](../../DESIGN.md)

---

## スコア計算ルール

| アクション | 基本点 | 計算式 |
|------------|--------|--------|
| 1ライン消去（Single） | 100 | 100 × Level |
| 2ライン消去（Double） | 300 | 300 × Level |
| 3ライン消去（Triple） | 500 | 500 × Level |
| 4ライン消去（Tetris） | 800 | 800 × Level |
| ソフトドロップ | 1/マス | 落下距離 × 1 |
| ハードドロップ | 2/マス | 落下距離 × 2 |

---

## レベルアップ条件

- 10ライン消去ごとにレベルアップ
- Level 1: 1.0秒/マス → Level 15: 0.1秒/マス
- 最大レベル: 15

### 落下速度計算

```dart
Duration getDropInterval(int level) {
  // Level 1: 1000ms → Level 15: 100ms
  final ms = 1000 - (level - 1) * 64;
  return Duration(milliseconds: ms.clamp(100, 1000));
}
```

---

## ディレクトリ構成

```
features/score/
├── domain/
│   ├── entities/
│   │   └── high_score.dart
│   └── repositories/
│       └── score_repository.dart
├── application/usecases/
│   ├── get_high_score_usecase.dart
│   ├── save_high_score_usecase.dart
│   └── reset_high_score_usecase.dart
├── infrastructure/
│   └── score_repository_impl.dart
└── providers/
    └── high_score_provider.dart
```

---

## Domain層

### HighScore

```dart
@immutable
class HighScore {
  final int score;
  final DateTime achievedAt;

  HighScore({required this.score, DateTime? achievedAt})
      : achievedAt = achievedAt ?? DateTime.now();

  bool isNewRecord(int newScore) => newScore > score;

  HighScore copyWith({int? score, DateTime? achievedAt}) {
    return HighScore(
      score: score ?? this.score,
      achievedAt: achievedAt ?? this.achievedAt,
    );
  }
}
```

### ScoreRepository

```dart
abstract class ScoreRepository {
  Future<Either<Failure, HighScore>> getHighScore();
  Future<Either<Failure, Unit>> saveHighScore(HighScore highScore);
  Future<Either<Failure, Unit>> resetHighScore();
}
```

---

## Application層

### GetHighScoreUseCase

```dart
class GetHighScoreUseCase {
  final ScoreRepository _repository;

  GetHighScoreUseCase(this._repository);

  Future<Either<Failure, HighScore>> execute() {
    return _repository.getHighScore();
  }
}
```

### SaveHighScoreUseCase

```dart
class SaveHighScoreUseCase {
  final ScoreRepository _repository;

  SaveHighScoreUseCase(this._repository);

  Future<Either<Failure, Unit>> execute(int score) async {
    final currentResult = await _repository.getHighScore();

    return currentResult.fold(
      (failure) => Left(failure),
      (current) {
        if (current.isNewRecord(score)) {
          return _repository.saveHighScore(HighScore(score: score));
        }
        return Right(unit);
      },
    );
  }
}
```

### ResetHighScoreUseCase

```dart
class ResetHighScoreUseCase {
  final ScoreRepository _repository;

  ResetHighScoreUseCase(this._repository);

  Future<Either<Failure, Unit>> execute() {
    return _repository.resetHighScore();
  }
}
```

---

## Infrastructure層

```dart
class ScoreRepositoryImpl implements ScoreRepository {
  static const _keyScore = 'high_score';
  static const _keyDate = 'high_score_date';
  final SharedPreferences _prefs;

  ScoreRepositoryImpl(this._prefs);

  @override
  Future<Either<Failure, HighScore>> getHighScore() async {
    try {
      final score = _prefs.getInt(_keyScore) ?? 0;
      final dateStr = _prefs.getString(_keyDate);
      final date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
      return Right(HighScore(score: score, achievedAt: date));
    } catch (e) {
      return Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveHighScore(HighScore highScore) async {
    try {
      await _prefs.setInt(_keyScore, highScore.score);
      await _prefs.setString(_keyDate, highScore.achievedAt.toIso8601String());
      return Right(unit);
    } catch (e) {
      return Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetHighScore() async {
    try {
      await _prefs.remove(_keyScore);
      await _prefs.remove(_keyDate);
      return Right(unit);
    } catch (e) {
      return Left(StorageFailure());
    }
  }
}
```

---

## Providers

```dart
final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ScoreRepositoryImpl(prefs);
});

final getHighScoreUseCaseProvider = Provider((ref) {
  return GetHighScoreUseCase(ref.watch(scoreRepositoryProvider));
});

final saveHighScoreUseCaseProvider = Provider((ref) {
  return SaveHighScoreUseCase(ref.watch(scoreRepositoryProvider));
});

final resetHighScoreUseCaseProvider = Provider((ref) {
  return ResetHighScoreUseCase(ref.watch(scoreRepositoryProvider));
});

final highScoreProvider = FutureProvider<HighScore>((ref) async {
  final useCase = ref.watch(getHighScoreUseCaseProvider);
  final result = await useCase.execute();
  return result.fold(
    (failure) => HighScore(score: 0),
    (highScore) => highScore,
  );
});
```

---

## テスト方針

| 対象 | 内容 |
|------|------|
| HighScore | isNewRecord判定、copyWith |
| SaveHighScoreUseCase | 新記録時のみ保存、既存より低い場合は保存しない |
| ScoreRepositoryImpl | SharedPreferences操作、日付の保存・復元 |
