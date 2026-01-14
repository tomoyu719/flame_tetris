import 'dart:math';

import 'package:tetris_domain/tetris_domain.dart';

/// 7-bagアルゴリズムに基づくテトリミノ生成器
///
/// テトリスガイドライン準拠の公平なピース生成を行う。
/// 7種類のテトリミノを1つずつ含む「袋」からランダムに取り出し、
/// 袋が空になったら新しい袋を作成する。
class TetrominoGenerator {
  /// TetrominoGeneratorを生成
  ///
  /// [random]: 乱数生成器（テスト用にシード指定可能）
  TetrominoGenerator({Random? random}) : _random = random ?? Random() {
    _fillBag();
  }

  final Random _random;

  /// 現在の袋（シャッフル済みのテトリミノリスト）
  final List<TetrominoType> _currentBag = [];

  /// 次の袋（先読み用）
  final List<TetrominoType> _nextBag = [];

  /// 次のテトリミノを取得する
  ///
  /// 袋から1つ取り出し、袋が空になったら新しい袋を生成する。
  TetrominoType next() {
    if (_currentBag.isEmpty) {
      _refillFromNextBag();
    }
    return _currentBag.removeAt(0);
  }

  /// 次のテトリミノをプレビューする（取り出さない）
  TetrominoType peek() {
    _ensureBagHasItems(1);
    return _currentBag.first;
  }

  /// 複数のテトリミノをプレビューする（取り出さない）
  ///
  /// [count]: プレビューする個数
  List<TetrominoType> peekMultiple(int count) {
    _ensureBagHasItems(count);

    final result = <TetrominoType>[];
    var remaining = count;

    // 現在の袋から取得
    final fromCurrent = remaining.clamp(0, _currentBag.length);
    result.addAll(_currentBag.take(fromCurrent));
    remaining -= fromCurrent;

    // 次の袋から取得
    if (remaining > 0) {
      final fromNext = remaining.clamp(0, _nextBag.length);
      result.addAll(_nextBag.take(fromNext));
    }

    return result;
  }

  /// ジェネレーターをリセットし、新しい袋から開始する
  void reset() {
    _currentBag.clear();
    _nextBag.clear();
    _fillBag();
  }

  /// 袋に指定個数以上のアイテムがあることを保証する
  void _ensureBagHasItems(int count) {
    // 次の袋も含めて十分な数があるか確認
    while (_currentBag.length + _nextBag.length < count) {
      _generateNextBag();
    }

    // 現在の袋が空なら次の袋から補充
    if (_currentBag.isEmpty && _nextBag.isNotEmpty) {
      _refillFromNextBag();
    }
  }

  /// 現在の袋と次の袋を初期化
  void _fillBag() {
    _generateCurrentBag();
    _generateNextBag();
  }

  /// 現在の袋を生成
  void _generateCurrentBag() {
    _currentBag
      ..clear()
      ..addAll(_createShuffledBag());
  }

  /// 次の袋を生成
  void _generateNextBag() {
    _nextBag
      ..clear()
      ..addAll(_createShuffledBag());
  }

  /// 次の袋を現在の袋に移動し、新しい次の袋を生成
  void _refillFromNextBag() {
    _currentBag
      ..clear()
      ..addAll(_nextBag);
    _generateNextBag();
  }

  /// シャッフルされた7つのテトリミノを含むリストを作成
  List<TetrominoType> _createShuffledBag() {
    return List<TetrominoType>.from(TetrominoType.values)..shuffle(_random);
  }
}
