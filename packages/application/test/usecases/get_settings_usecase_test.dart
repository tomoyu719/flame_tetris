import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late GetSettingsUseCase usecase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    usecase = GetSettingsUseCase(mockRepository);
  });

  group('GetSettingsUseCase', () {
    group('execute', () {
      test('リポジトリから設定を取得できる', () async {
        final settings = GameSettings(
          soundEffectVolume: 0.8,
          bgmVolume: 0.6,
          showGhost: false,
          isMuted: true,
        );
        when(
          () => mockRepository.getSettings(),
        ).thenAnswer((_) async => settings);

        final result = await usecase.execute();

        expect(result.soundEffectVolume, equals(0.8));
        expect(result.bgmVolume, equals(0.6));
        expect(result.showGhost, isFalse);
        expect(result.isMuted, isTrue);
        verify(() => mockRepository.getSettings()).called(1);
      });

      test('デフォルト設定を取得できる', () async {
        when(
          () => mockRepository.getSettings(),
        ).thenAnswer((_) async => GameSettings());

        final result = await usecase.execute();

        expect(result.soundEffectVolume, equals(1.0));
        expect(result.bgmVolume, equals(0.5));
        expect(result.showGhost, isTrue);
        expect(result.isMuted, isFalse);
      });
    });

    group('executeKeyBindings', () {
      test('リポジトリからキーバインドを取得できる', () async {
        final bindings = KeyBindings(
          bindings: const {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
          },
        );
        when(
          () => mockRepository.getKeyBindings(),
        ).thenAnswer((_) async => bindings);

        final result = await usecase.executeKeyBindings();

        expect(result.getKey(GameAction.moveLeft), equals('KeyA'));
        expect(result.getKey(GameAction.moveRight), equals('KeyD'));
        verify(() => mockRepository.getKeyBindings()).called(1);
      });

      test('デフォルトキーバインドを取得できる', () async {
        when(
          () => mockRepository.getKeyBindings(),
        ).thenAnswer((_) async => KeyBindings());

        final result = await usecase.executeKeyBindings();

        expect(result.getKey(GameAction.moveLeft), equals('ArrowLeft'));
        expect(result.getKey(GameAction.moveRight), equals('ArrowRight'));
        expect(result.getKey(GameAction.hardDrop), equals('Space'));
      });
    });
  });
}
