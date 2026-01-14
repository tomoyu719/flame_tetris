import 'package:tetris_application/src/services/tetromino_generator.dart';
import 'package:tetris_application/src/usecases/usecases.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// ゲーム全体を制御するコントローラー
///
/// すべてのUseCaseを統合し、ゲームの状態管理と操作を提供する。
/// UIレイヤーはこのコントローラーを通じてゲームを操作する。
class GameController {
  /// GameControllerを生成
  ///
  /// [generator]: テトリミノ生成器
  /// [collisionService]: 衝突判定サービス
  /// [rotationService]: 回転サービス
  /// [lineClearService]: ライン消去サービス
  /// [scoringService]: スコア計算サービス
  GameController({
    required TetrominoGenerator generator,
    required CollisionService collisionService,
    required RotationService rotationService,
    required LineClearService lineClearService,
    required ScoringService scoringService,
  }) : _generator = generator,
       _collisionService = collisionService,
       _startGameUseCase = const StartGameUseCase(),
       _moveTetrominoUseCase = MoveTetrominoUseCase(
         collisionService: collisionService,
       ),
       _rotateTetrominoUseCase = RotateTetrominoUseCase(
         rotationService: rotationService,
       ),
       _softDropUseCase = SoftDropUseCase(
         collisionService: collisionService,
         scoringService: scoringService,
       ),
       _hardDropUseCase = HardDropUseCase(
         collisionService: collisionService,
         scoringService: scoringService,
       ),
       _holdTetrominoUseCase = const HoldTetrominoUseCase(),
       _pauseGameUseCase = const PauseGameUseCase(),
       _gameTickUseCase = GameTickUseCase(
         collisionService: collisionService,
         lineClearService: lineClearService,
         scoringService: scoringService,
       );

  final TetrominoGenerator _generator;
  final CollisionService _collisionService;

  // UseCases
  final StartGameUseCase _startGameUseCase;
  final MoveTetrominoUseCase _moveTetrominoUseCase;
  final RotateTetrominoUseCase _rotateTetrominoUseCase;
  final SoftDropUseCase _softDropUseCase;
  final HardDropUseCase _hardDropUseCase;
  final HoldTetrominoUseCase _holdTetrominoUseCase;
  final PauseGameUseCase _pauseGameUseCase;
  final GameTickUseCase _gameTickUseCase;

  /// 現在のゲーム状態
  GameState? _state;

  /// 現在のゲーム状態を取得
  GameState? get state => _state;

  /// ゲームがプレイ中かどうか
  bool get isPlaying => _state?.status == GameStatus.playing;

  /// ゲームが一時停止中かどうか
  bool get isPaused => _state?.status == GameStatus.paused;

  /// ゲームオーバーかどうか
  bool get isGameOver => _state?.status == GameStatus.gameOver;

  /// ゴースト位置を取得
  Tetromino? get ghostPosition {
    if (_state == null || _state!.currentTetromino == null) {
      return null;
    }
    return _collisionService.getGhostPosition(
      _state!.currentTetromino!,
      _state!.board,
    );
  }

  /// ゲームを開始する
  ///
  /// [nextQueueSize]: NEXTキューのサイズ（デフォルト3）
  void startGame({int nextQueueSize = 3}) {
    _generator.reset();
    _state = _startGameUseCase.execute(
      _generator.next,
      nextQueueSize: nextQueueSize,
    );
  }

  /// ゲームをリスタートする
  ///
  /// 現在のゲーム状態をリセットして新しいゲームを開始する。
  void restart({int nextQueueSize = 3}) {
    startGame(nextQueueSize: nextQueueSize);
  }

  /// テトリミノを移動する
  ///
  /// [direction]: 移動方向
  /// Returns: 移動成功かどうか
  bool move(MoveDirection direction) {
    if (_state == null) return false;

    final result = _moveTetrominoUseCase.execute(_state!, direction);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// テトリミノを回転する
  ///
  /// [direction]: 回転方向
  /// Returns: 回転成功かどうか
  bool rotate(RotationDirection direction) {
    if (_state == null) return false;

    final result = _rotateTetrominoUseCase.execute(_state!, direction);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// ソフトドロップする
  ///
  /// Returns: ドロップ成功かどうか
  bool softDrop() {
    if (_state == null) return false;

    final result = _softDropUseCase.execute(_state!);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// ハードドロップする
  ///
  /// テトリミノを即座に最下部まで落下させ、ロック処理を行う。
  /// Returns: ドロップ成功かどうか
  bool hardDrop() {
    if (_state == null) return false;

    // まずハードドロップで最下部まで移動
    final dropResult = _hardDropUseCase.execute(_state!);
    if (!dropResult.isSuccess) {
      return false;
    }
    _state = dropResult.state;

    // その後、強制ロックで着地処理
    final lockResult = _gameTickUseCase.execute(
      _state!,
      _getNextTetromino,
      forceLock: true,
    );
    if (lockResult.isSuccess) {
      _state = lockResult.state;
    }
    return true;
  }

  /// テトリミノをホールドする
  ///
  /// Returns: ホールド成功かどうか
  bool hold() {
    if (_state == null) return false;

    final result = _holdTetrominoUseCase.execute(_state!, _getNextTetromino);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// ゲームを一時停止する
  ///
  /// Returns: 一時停止成功かどうか
  bool pause() {
    if (_state == null) return false;

    final result = _pauseGameUseCase.pause(_state!);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// ゲームを再開する
  ///
  /// Returns: 再開成功かどうか
  bool resume() {
    if (_state == null) return false;

    final result = _pauseGameUseCase.resume(_state!);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// 一時停止/再開をトグルする
  ///
  /// Returns: トグル成功かどうか
  bool togglePause() {
    if (_state == null) return false;

    final result = _pauseGameUseCase.toggle(_state!);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// ゲームティックを実行する（自動落下）
  ///
  /// タイマーから定期的に呼び出される。
  /// Returns: ティック成功かどうか
  bool tick() {
    if (_state == null) return false;

    final result = _gameTickUseCase.execute(_state!, _getNextTetromino);
    if (result.isSuccess) {
      _state = result.state;
      return true;
    }
    return false;
  }

  /// テスト用: 状態を強制的に設定する
  ///
  /// 本番コードでは使用しないこと。
  // テスト用メソッドのため、メソッド形式を維持
  // ignore: use_setters_to_change_properties
  void forceState(GameState newState) {
    _state = newState;
  }

  /// 次のテトリミノを取得するヘルパー
  Tetromino _getNextTetromino() {
    return Tetromino.spawn(_generator.next());
  }
}
