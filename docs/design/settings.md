# settings - 設定機能

[← 設計書トップ](../../DESIGN.md)

---

## ワイヤーフレーム

```
┌─────────────────────────────────────┐
│          ┌─────────────────┐        │
│          │    SETTINGS     │        │
│          └─────────────────┘        │
│                                     │
│   BGM Volume                        │
│   ├──────────●──────────┤  70%     │
│                                     │
│   SE Volume                         │
│   ├────────────────●────┤  90%     │
│                                     │
│   Ghost Piece                       │
│   ┌─────────┐ ┌─────────┐          │
│   │   ON    │ │   OFF   │          │
│   └─────────┘ └─────────┘          │
│                                     │
│   ┌─────────────────────┐          │
│   │   RESET HIGH SCORE  │          │
│   └─────────────────────┘          │
│                                     │
│          ┌─────────────────┐        │
│          │      BACK       │        │
│          └─────────────────┘        │
│                                     │
└─────────────────────────────────────┘
```

---

## 要素説明

| 要素 | 説明 |
|------|------|
| BGM Volume | BGM音量（0-100%） |
| SE Volume | 効果音音量（0-100%） |
| Ghost Piece | ゴーストピース表示ON/OFF |
| RESET HIGH SCORE | ハイスコアリセット（確認ダイアログ） |

---

## ディレクトリ構成

```
features/settings/
├── domain/
│   ├── entities/
│   │   └── game_settings.dart
│   └── repositories/
│       └── settings_repository.dart
├── application/usecases/
│   ├── get_settings_usecase.dart
│   ├── save_settings_usecase.dart
│   └── reset_settings_usecase.dart
├── infrastructure/
│   └── settings_repository_impl.dart
├── presentation/
│   ├── screens/
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── volume_slider.dart
│       └── toggle_setting.dart
└── providers/
    └── game_settings_provider.dart
```

---

## Domain層

### GameSettings

```dart
@immutable
class GameSettings {
  final double bgmVolume;       // 0.0 - 1.0
  final double seVolume;        // 0.0 - 1.0
  final bool showGhost;

  const GameSettings({
    this.bgmVolume = 0.7,
    this.seVolume = 0.9,
    this.showGhost = true,
  });

  static const defaultSettings = GameSettings();

  GameSettings copyWith({
    double? bgmVolume,
    double? seVolume,
    bool? showGhost,
  }) {
    return GameSettings(
      bgmVolume: bgmVolume ?? this.bgmVolume,
      seVolume: seVolume ?? this.seVolume,
      showGhost: showGhost ?? this.showGhost,
    );
  }

  Map<String, dynamic> toJson() => {
    'bgmVolume': bgmVolume,
    'seVolume': seVolume,
    'showGhost': showGhost,
  };

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      bgmVolume: (json['bgmVolume'] as num?)?.toDouble() ?? 0.7,
      seVolume: (json['seVolume'] as num?)?.toDouble() ?? 0.9,
      showGhost: json['showGhost'] as bool? ?? true,
    );
  }
}
```

### SettingsRepository

```dart
abstract class SettingsRepository {
  Future<Either<Failure, GameSettings>> getSettings();
  Future<Either<Failure, Unit>> saveSettings(GameSettings settings);
  Future<Either<Failure, Unit>> resetSettings();
}
```

---

## Infrastructure層

```dart
class SettingsRepositoryImpl implements SettingsRepository {
  static const _key = 'game_settings';
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<Either<Failure, GameSettings>> getSettings() async {
    try {
      final json = _prefs.getString(_key);
      if (json == null) return Right(GameSettings.defaultSettings);
      return Right(GameSettings.fromJson(jsonDecode(json)));
    } catch (e) {
      return Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(GameSettings settings) async {
    try {
      await _prefs.setString(_key, jsonEncode(settings.toJson()));
      return Right(unit);
    } catch (e) {
      return Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetSettings() async {
    try {
      await _prefs.remove(_key);
      return Right(unit);
    } catch (e) {
      return Left(StorageFailure());
    }
  }
}
```

---

## Presentation層

### SettingsScreen

```dart
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(gameSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('SETTINGS')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          VolumeSlider(
            label: 'BGM Volume',
            value: settings.bgmVolume,
            onChanged: (value) => _updateSettings(
              ref,
              settings.copyWith(bgmVolume: value),
            ),
          ),
          VolumeSlider(
            label: 'SE Volume',
            value: settings.seVolume,
            onChanged: (value) => _updateSettings(
              ref,
              settings.copyWith(seVolume: value),
            ),
          ),
          ToggleSetting(
            label: 'Ghost Piece',
            value: settings.showGhost,
            onChanged: (value) => _updateSettings(
              ref,
              settings.copyWith(showGhost: value),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _showResetConfirmDialog(context, ref),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('RESET HIGH SCORE'),
          ),
        ],
      ),
    );
  }

  void _updateSettings(WidgetRef ref, GameSettings settings) {
    ref.read(gameSettingsProvider.notifier).updateSettings(settings);
  }

  void _showResetConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset High Score?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              ref.read(resetHighScoreUseCaseProvider).execute();
              Navigator.pop(context);
            },
            child: Text('RESET'),
          ),
        ],
      ),
    );
  }
}
```

### VolumeSlider

```dart
class VolumeSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
            SizedBox(
              width: 50,
              child: Text('${(value * 100).round()}%'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### ToggleSetting

```dart
class ToggleSetting extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
```

---

## Providers

```dart
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(sharedPreferencesProvider));
});

final gameSettingsProvider = StateNotifierProvider<GameSettingsNotifier, GameSettings>((ref) {
  return GameSettingsNotifier(ref.watch(settingsRepositoryProvider));
});

class GameSettingsNotifier extends StateNotifier<GameSettings> {
  final SettingsRepository _repository;

  GameSettingsNotifier(this._repository) : super(GameSettings.defaultSettings) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final result = await _repository.getSettings();
    result.fold(
      (failure) => {},
      (settings) => state = settings,
    );
  }

  Future<void> updateSettings(GameSettings settings) async {
    await _repository.saveSettings(settings);
    state = settings;
  }
}
```

---

## テスト方針

| 対象 | 内容 |
|------|------|
| GameSettings | JSON変換、copyWith、デフォルト値 |
| SettingsRepositoryImpl | 保存・読込・リセット |
| GameSettingsNotifier | 状態更新、初期読み込み |
