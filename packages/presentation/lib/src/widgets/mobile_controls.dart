import 'package:flutter/material.dart';

/// モバイル用のゲームコントロールボタン
class MobileControls extends StatelessWidget {
  /// MobileControlsを生成
  const MobileControls({
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onSoftDrop,
    required this.onHardDrop,
    required this.onRotateClockwise,
    required this.onRotateCounterClockwise,
    required this.onHold,
    required this.onPause,
    super.key,
  });

  /// 左移動
  final VoidCallback onMoveLeft;

  /// 右移動
  final VoidCallback onMoveRight;

  /// ソフトドロップ
  final VoidCallback onSoftDrop;

  /// ハードドロップ
  final VoidCallback onHardDrop;

  /// 時計回り回転
  final VoidCallback onRotateClockwise;

  /// 反時計回り回転
  final VoidCallback onRotateCounterClockwise;

  /// ホールド
  final VoidCallback onHold;

  /// 一時停止
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左側: 方向キー
        _buildDirectionPad(),

        // 中央: ホールド・一時停止
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ControlButton(
              icon: Icons.pause,
              onPressed: onPause,
              size: 40,
            ),
            const SizedBox(height: 8),
            _ControlButton(
              icon: Icons.swap_horiz,
              onPressed: onHold,
              size: 40,
              label: 'HOLD',
            ),
          ],
        ),

        // 右側: 回転・ドロップ
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDirectionPad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 上（ハードドロップ）
        _ControlButton(
          icon: Icons.keyboard_double_arrow_down,
          onPressed: onHardDrop,
          size: 48,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 左
            _RepeatableButton(
              icon: Icons.arrow_left,
              onPressed: onMoveLeft,
              size: 48,
            ),
            const SizedBox(width: 48), // 中央スペース
            // 右
            _RepeatableButton(
              icon: Icons.arrow_right,
              onPressed: onMoveRight,
              size: 48,
            ),
          ],
        ),
        const SizedBox(height: 4),
        // 下（ソフトドロップ）
        _RepeatableButton(
          icon: Icons.arrow_drop_down,
          onPressed: onSoftDrop,
          size: 48,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 反時計回り
            _ControlButton(
              icon: Icons.rotate_left,
              onPressed: onRotateCounterClockwise,
              size: 56,
            ),
            const SizedBox(width: 8),
            // 時計回り
            _ControlButton(
              icon: Icons.rotate_right,
              onPressed: onRotateClockwise,
              size: 56,
            ),
          ],
        ),
      ],
    );
  }
}

/// コントロールボタン
class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    this.label,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: const Color(0xFF2A2A4E),
          borderRadius: BorderRadius.circular(size / 4),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size / 4),
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: Colors.white70,
                size: size * 0.6,
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: const TextStyle(
              color: Color(0xFF8888AA),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

/// 長押しで繰り返し発火するボタン
class _RepeatableButton extends StatefulWidget {
  const _RepeatableButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  State<_RepeatableButton> createState() => _RepeatableButtonState();
}

class _RepeatableButtonState extends State<_RepeatableButton> {
  bool _isPressed = false;

  void _startRepeating() {
    _isPressed = true;
    widget.onPressed();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_isPressed) {
        _repeatAction();
      }
    });
  }

  void _repeatAction() {
    if (!_isPressed) return;

    widget.onPressed();

    Future.delayed(const Duration(milliseconds: 50), () {
      if (_isPressed) {
        _repeatAction();
      }
    });
  }

  void _stopRepeating() {
    _isPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startRepeating(),
      onTapUp: (_) => _stopRepeating(),
      onTapCancel: _stopRepeating,
      child: Material(
        color: const Color(0xFF2A2A4E),
        borderRadius: BorderRadius.circular(widget.size / 4),
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            color: Colors.white70,
            size: widget.size * 0.6,
          ),
        ),
      ),
    );
  }
}
