import 'package:flutter/material.dart';

/// 音量スライダーウィジェット
///
/// ラベルとパーセンテージ表示付きのスライダー。
class VolumeSlider extends StatelessWidget {
  /// VolumeSliderを生成
  const VolumeSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// ラベル
  final String label;

  /// 現在の値（0.0 - 1.0）
  final double value;

  /// 値変更時のコールバック
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.cyan,
                    inactiveTrackColor: Colors.grey[800],
                    thumbColor: Colors.cyan,
                    overlayColor: Colors.cyan.withValues(alpha: 0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: value,
                    onChanged: onChanged,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
