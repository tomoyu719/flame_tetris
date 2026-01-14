import 'package:meta/meta.dart';

/// 失敗を表す基底クラス
///
/// すべてのFailureはこのクラスを継承する。
/// Exceptionを使わずにエラーを値として表現することで、
/// 型安全なエラーハンドリングを実現する。
@immutable
abstract class Failure {
  const Failure({this.message});

  /// エラーメッセージ（オプション）
  final String? message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.runtimeType == runtimeType &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    if (message != null) {
      return '$runtimeType: $message';
    }
    return '$runtimeType';
  }
}
