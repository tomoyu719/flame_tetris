import 'package:flutter/material.dart';

/// トグル設定ウィジェット
///
/// ラベルとスイッチによるON/OFF設定。
class ToggleSetting extends StatelessWidget {
  /// ToggleSettingを生成
  const ToggleSetting({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// ラベル
  final String label;

  /// 現在の値
  final bool value;

  /// 値変更時のコールバック
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.cyan,
            activeTrackColor: Colors.cyan.withValues(alpha: 0.5),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }
}
