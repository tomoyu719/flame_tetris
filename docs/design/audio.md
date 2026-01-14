# audio - オーディオ機能

[← 設計書トップ](../../DESIGN.md)

---

## ディレクトリ構成

```
features/audio/
├── domain/services/
│   └── audio_service.dart
├── infrastructure/
│   └── audio_service_impl.dart
└── providers/
    └── audio_service_provider.dart
```

---

## Domain層

### AudioService

```dart
abstract class AudioService {
  // BGM
  Future<void> playBgm();
  Future<void> stopBgm();
  Future<void> pauseBgm();
  Future<void> resumeBgm();
  Future<void> setBgmVolume(double volume);

  // 効果音
  Future<void> playMove();
  Future<void> playRotate();
  Future<void> playDrop();
  Future<void> playLineClear(int lineCount);
  Future<void> playTetris();      // 4ライン消し
  Future<void> playLevelUp();
  Future<void> playGameOver();
  Future<void> setSeVolume(double volume);

  // リソース管理
  Future<void> preloadAll();
  void dispose();
}
```

---

## Infrastructure層

```dart
class AudioServiceImpl implements AudioService {
  final FlameAudio _audio = FlameAudio();
  AudioPlayer? _bgmPlayer;

  double _bgmVolume = 0.7;
  double _seVolume = 0.9;

  @override
  Future<void> preloadAll() async {
    await _audio.audioCache.loadAll([
      'bgm/main_theme.mp3',
      'se/move.wav',
      'se/rotate.wav',
      'se/drop.wav',
      'se/line_clear.wav',
      'se/tetris.wav',
      'se/level_up.wav',
      'se/game_over.wav',
    ]);
  }

  // --- BGM ---

  @override
  Future<void> playBgm() async {
    _bgmPlayer = await _audio.loopLongAudio(
      'bgm/main_theme.mp3',
      volume: _bgmVolume,
    );
  }

  @override
  Future<void> stopBgm() async {
    await _bgmPlayer?.stop();
    _bgmPlayer = null;
  }

  @override
  Future<void> pauseBgm() async {
    await _bgmPlayer?.pause();
  }

  @override
  Future<void> resumeBgm() async {
    await _bgmPlayer?.resume();
  }

  @override
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume;
    await _bgmPlayer?.setVolume(volume);
  }

  // --- 効果音 ---

  @override
  Future<void> playMove() async {
    await _audio.play('se/move.wav', volume: _seVolume);
  }

  @override
  Future<void> playRotate() async {
    await _audio.play('se/rotate.wav', volume: _seVolume);
  }

  @override
  Future<void> playDrop() async {
    await _audio.play('se/drop.wav', volume: _seVolume);
  }

  @override
  Future<void> playLineClear(int lineCount) async {
    if (lineCount == 4) {
      await playTetris();
    } else {
      await _audio.play('se/line_clear.wav', volume: _seVolume);
    }
  }

  @override
  Future<void> playTetris() async {
    await _audio.play('se/tetris.wav', volume: _seVolume);
  }

  @override
  Future<void> playLevelUp() async {
    await _audio.play('se/level_up.wav', volume: _seVolume);
  }

  @override
  Future<void> playGameOver() async {
    await _audio.play('se/game_over.wav', volume: _seVolume);
  }

  @override
  Future<void> setSeVolume(double volume) async {
    _seVolume = volume;
  }

  // --- リソース管理 ---

  @override
  void dispose() {
    _bgmPlayer?.dispose();
    _audio.audioCache.clearAll();
  }
}
```

---

## Providers

```dart
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioServiceImpl();
  ref.onDispose(() => service.dispose());
  return service;
});

// 設定との連携
final audioControllerProvider = Provider((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final settings = ref.watch(gameSettingsProvider);

  // 設定変更時に音量を更新
  audioService.setBgmVolume(settings.bgmVolume);
  audioService.setSeVolume(settings.seVolume);

  return audioService;
});
```

---

## オーディオファイル構成

```
assets/audio/
├── bgm/
│   └── main_theme.mp3
└── se/
    ├── move.wav
    ├── rotate.wav
    ├── drop.wav
    ├── line_clear.wav
    ├── tetris.wav
    ├── level_up.wav
    └── game_over.wav
```

---

## pubspec.yaml設定

```yaml
flutter:
  assets:
    - assets/audio/bgm/
    - assets/audio/se/
```

---

## GameControllerとの連携

```dart
class GameController extends ChangeNotifier {
  final AudioService _audioService;

  void move(MoveDirection direction) {
    _moveUseCase.execute(_state, direction).fold(
      (failure) => {},
      (newState) {
        _state = newState;
        _audioService.playMove(); // 移動音
        notifyListeners();
      },
    );
  }

  void rotate(RotationDirection direction) {
    _rotateUseCase.execute(_state, direction).fold(
      (failure) => {},
      (newState) {
        _state = newState;
        _audioService.playRotate(); // 回転音
        notifyListeners();
      },
    );
  }

  void hardDrop() {
    _hardDropUseCase.execute(_state).fold(
      (failure) => {},
      (newState) {
        _state = newState;
        _audioService.playDrop(); // ドロップ音
        notifyListeners();
      },
    );
  }

  void _handleLineClear(int lineCount) {
    if (lineCount > 0) {
      _audioService.playLineClear(lineCount);
    }
  }

  void _handleLevelUp() {
    _audioService.playLevelUp();
  }

  void _handleGameOver() {
    _audioService.stopBgm();
    _audioService.playGameOver();
  }
}
```

---

## テスト方針

| 対象 | 内容 |
|------|------|
| AudioServiceImpl | モック使用、メソッド呼び出し確認 |
| audioControllerProvider | 設定変更時の音量更新 |

### テスト用モック

```dart
class MockAudioService implements AudioService {
  final List<String> calledMethods = [];

  @override
  Future<void> playMove() async {
    calledMethods.add('playMove');
  }

  // ... 他のメソッドも同様
}
```
