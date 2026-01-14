import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late SaveSettingsUseCase usecase;
  late MockSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(GameSettings());
    registerFallbackValue(KeyBindings());
  });

  setUp(() {
    mockRepository = MockSettingsRepository();
    usecase = SaveSettingsUseCase(mockRepository);
  });

  group('SaveSettingsUseCase', () {
    group('execute', () {
      test('設定を保存できる', () async {
        final settings = GameSettings(
          soundEffectVolume: 0.7,
          bgmVolume: 0.4,
          showGhost: false,
          isMuted: true,
        );
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => true);

        final result = await usecase.execute(settings);

        expect(result, isTrue);
        verify(() => mockRepository.saveSettings(settings)).called(1);
      });

      test('保存失敗時はfalseを返す', () async {
        final settings = GameSettings();
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => false);

        final result = await usecase.execute(settings);

        expect(result, isFalse);
      });
    });

    group('executeKeyBindings', () {
      test('キーバインドを保存できる', () async {
        final bindings = KeyBindings(
          bindings: {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
          },
        );
        when(() => mockRepository.saveKeyBindings(any()))
            .thenAnswer((_) async => true);

        final result = await usecase.executeKeyBindings(bindings);

        expect(result, isTrue);
        verify(() => mockRepository.saveKeyBindings(bindings)).called(1);
      });

      test('保存失敗時はfalseを返す', () async {
        final bindings = KeyBindings();
        when(() => mockRepository.saveKeyBindings(any()))
            .thenAnswer((_) async => false);

        final result = await usecase.executeKeyBindings(bindings);

        expect(result, isFalse);
      });
    });

    group('executeReset', () {
      test('設定をリセットできる', () async {
        when(() => mockRepository.resetToDefaults())
            .thenAnswer((_) async => true);

        final result = await usecase.executeReset();

        expect(result, isTrue);
        verify(() => mockRepository.resetToDefaults()).called(1);
      });

      test('リセット失敗時はfalseを返す', () async {
        when(() => mockRepository.resetToDefaults())
            .thenAnswer((_) async => false);

        final result = await usecase.executeReset();

        expect(result, isFalse);
      });
    });
  });
}
