/// ゲームの状態を表す列挙型
enum GameStatus {
  /// ゲーム開始前の準備状態
  ready,

  /// ゲームプレイ中
  playing,

  /// 一時停止中
  paused,

  /// ゲームオーバー
  gameOver,
}
