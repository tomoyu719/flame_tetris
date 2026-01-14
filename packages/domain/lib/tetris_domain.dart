/// Domain layer for Flame Tetris
///
/// Contains:
/// - Entities (Tetromino, Board, GameState, etc.)
/// - Value Objects (Level, LinesCleared, etc.)
/// - Service interfaces (CollisionService, RotationService, etc.)
/// - Enums (TetrominoType, RotationState, etc.)
library;

export 'src/constants/constants.dart';
export 'src/entities/entities.dart';
export 'src/enums/enums.dart';
export 'src/failures/failures.dart';
export 'src/repositories/repositories.dart';
export 'src/services/services.dart';
export 'src/value_objects/value_objects.dart';
