import 'package:flutter/material.dart';

/// デバイスタイプ
enum DeviceType {
  /// モバイル（compact: < 600px）
  mobile,

  /// タブレット（medium: 600-840px）
  tablet,

  /// デスクトップ（expanded: > 840px）
  desktop,
}

/// レスポンシブレイアウトのブレークポイント
class Breakpoints {
  const Breakpoints._();

  /// モバイル/タブレットの境界
  static const double compact = 600;

  /// タブレット/デスクトップの境界
  static const double expanded = 840;
}

/// レスポンシブ情報を提供するInheritedWidget
class ResponsiveData extends InheritedWidget {
  /// ResponsiveDataを生成
  const ResponsiveData({
    required this.deviceType,
    required this.screenWidth,
    required this.screenHeight,
    required super.child,
    super.key,
  });

  /// デバイスタイプ
  final DeviceType deviceType;

  /// 画面幅
  final double screenWidth;

  /// 画面高さ
  final double screenHeight;

  /// モバイルかどうか
  bool get isMobile => deviceType == DeviceType.mobile;

  /// タブレットかどうか
  bool get isTablet => deviceType == DeviceType.tablet;

  /// デスクトップかどうか
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// モバイルまたはタブレットかどうか
  bool get isMobileOrTablet =>
      deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

  /// タブレットまたはデスクトップかどうか
  bool get isTabletOrDesktop =>
      deviceType == DeviceType.tablet || deviceType == DeviceType.desktop;

  /// 最寄りのResponsiveDataを取得
  static ResponsiveData of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<ResponsiveData>();
    assert(data != null, 'ResponsiveData not found in widget tree');
    return data!;
  }

  /// 最寄りのResponsiveDataを取得（nullを許容）
  static ResponsiveData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveData>();
  }

  @override
  bool updateShouldNotify(ResponsiveData oldWidget) {
    return deviceType != oldWidget.deviceType ||
        screenWidth != oldWidget.screenWidth ||
        screenHeight != oldWidget.screenHeight;
  }
}

/// レスポンシブレイアウトを提供するウィジェット
///
/// 画面サイズに応じてDeviceTypeを判定し、子ウィジェットにResponsiveDataを提供する。
class ResponsiveLayout extends StatelessWidget {
  /// ResponsiveLayoutを生成
  const ResponsiveLayout({
    required this.child,
    super.key,
  });

  /// 子ウィジェット
  final Widget child;

  /// 画面幅からDeviceTypeを判定
  static DeviceType getDeviceType(double width) {
    if (width < Breakpoints.compact) {
      return DeviceType.mobile;
    } else if (width < Breakpoints.expanded) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final deviceType = getDeviceType(width);

        return ResponsiveData(
          deviceType: deviceType,
          screenWidth: width,
          screenHeight: height,
          child: child,
        );
      },
    );
  }
}

/// デバイスタイプに応じて異なるウィジェットを表示するビルダー
class ResponsiveBuilder extends StatelessWidget {
  /// ResponsiveBuilderを生成
  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  /// モバイル用ウィジェット（必須、フォールバック）
  final Widget mobile;

  /// タブレット用ウィジェット（省略時はmobileを使用）
  final Widget? tablet;

  /// デスクトップ用ウィジェット（省略時はtablet、それも無ければmobileを使用）
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveData.of(context);

    switch (responsive.deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// レスポンシブな値を提供するユーティリティ
class ResponsiveValue<T> {
  /// ResponsiveValueを生成
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// モバイル用の値
  final T mobile;

  /// タブレット用の値
  final T? tablet;

  /// デスクトップ用の値
  final T? desktop;

  /// 現在のデバイスタイプに応じた値を取得
  T resolve(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// BuildContext拡張メソッド
extension ResponsiveContextExtension on BuildContext {
  /// ResponsiveDataを取得
  ResponsiveData get responsive => ResponsiveData.of(this);

  /// デバイスタイプを取得
  DeviceType get deviceType => responsive.deviceType;

  /// モバイルかどうか
  bool get isMobile => responsive.isMobile;

  /// タブレットかどうか
  bool get isTablet => responsive.isTablet;

  /// デスクトップかどうか
  bool get isDesktop => responsive.isDesktop;

  /// レスポンシブな値を解決
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveValue<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).resolve(deviceType);
  }
}

/// レスポンシブなスペーシング値
class ResponsiveSpacing {
  const ResponsiveSpacing._();

  /// 小さいスペーシング
  static double small(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 8,
      tablet: 12,
      desktop: 16,
    ).resolve(deviceType);
  }

  /// 中程度のスペーシング
  static double medium(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 16,
      tablet: 24,
      desktop: 32,
    ).resolve(deviceType);
  }

  /// 大きいスペーシング
  static double large(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 24,
      tablet: 40,
      desktop: 60,
    ).resolve(deviceType);
  }

  /// 特大のスペーシング
  static double extraLarge(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 40,
      tablet: 60,
      desktop: 80,
    ).resolve(deviceType);
  }
}

/// レスポンシブなフォントサイズ
class ResponsiveFontSize {
  const ResponsiveFontSize._();

  /// 見出し（大）
  static double headlineLarge(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 24,
      tablet: 32,
      desktop: 40,
    ).resolve(deviceType);
  }

  /// 見出し（中）
  static double headlineMedium(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 18,
      tablet: 24,
      desktop: 28,
    ).resolve(deviceType);
  }

  /// 見出し（小）
  static double headlineSmall(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 14,
      tablet: 16,
      desktop: 20,
    ).resolve(deviceType);
  }

  /// 本文
  static double body(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 10,
      tablet: 12,
      desktop: 14,
    ).resolve(deviceType);
  }

  /// キャプション
  static double caption(DeviceType deviceType) {
    return ResponsiveValue<double>(
      mobile: 8,
      tablet: 10,
      desktop: 12,
    ).resolve(deviceType);
  }
}
