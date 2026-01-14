import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_presentation/src/widgets/responsive_layout.dart';

void main() {
  group('ResponsiveLayout', () {
    group('getDeviceType', () {
      test('returns mobile for width < 600', () {
        expect(ResponsiveLayout.getDeviceType(400), DeviceType.mobile);
        expect(ResponsiveLayout.getDeviceType(599), DeviceType.mobile);
      });

      test('returns tablet for width 600-839', () {
        expect(ResponsiveLayout.getDeviceType(600), DeviceType.tablet);
        expect(ResponsiveLayout.getDeviceType(700), DeviceType.tablet);
        expect(ResponsiveLayout.getDeviceType(839), DeviceType.tablet);
      });

      test('returns desktop for width >= 840', () {
        expect(ResponsiveLayout.getDeviceType(840), DeviceType.desktop);
        expect(ResponsiveLayout.getDeviceType(1024), DeviceType.desktop);
        expect(ResponsiveLayout.getDeviceType(1920), DeviceType.desktop);
      });
    });
  });

  group('ResponsiveData', () {
    test('isMobile returns true for mobile device type', () {
      const data = ResponsiveData(
        deviceType: DeviceType.mobile,
        screenWidth: 400,
        screenHeight: 800,
        child: SizedBox(),
      );

      expect(data.isMobile, isTrue);
      expect(data.isTablet, isFalse);
      expect(data.isDesktop, isFalse);
    });

    test('isTablet returns true for tablet device type', () {
      const data = ResponsiveData(
        deviceType: DeviceType.tablet,
        screenWidth: 700,
        screenHeight: 600,
        child: SizedBox(),
      );

      expect(data.isMobile, isFalse);
      expect(data.isTablet, isTrue);
      expect(data.isDesktop, isFalse);
    });

    test('isDesktop returns true for desktop device type', () {
      const data = ResponsiveData(
        deviceType: DeviceType.desktop,
        screenWidth: 1024,
        screenHeight: 768,
        child: SizedBox(),
      );

      expect(data.isMobile, isFalse);
      expect(data.isTablet, isFalse);
      expect(data.isDesktop, isTrue);
    });

    test('isMobileOrTablet returns true for mobile and tablet', () {
      const mobileData = ResponsiveData(
        deviceType: DeviceType.mobile,
        screenWidth: 400,
        screenHeight: 800,
        child: SizedBox(),
      );
      const tabletData = ResponsiveData(
        deviceType: DeviceType.tablet,
        screenWidth: 700,
        screenHeight: 600,
        child: SizedBox(),
      );
      const desktopData = ResponsiveData(
        deviceType: DeviceType.desktop,
        screenWidth: 1024,
        screenHeight: 768,
        child: SizedBox(),
      );

      expect(mobileData.isMobileOrTablet, isTrue);
      expect(tabletData.isMobileOrTablet, isTrue);
      expect(desktopData.isMobileOrTablet, isFalse);
    });

    test('isTabletOrDesktop returns true for tablet and desktop', () {
      const mobileData = ResponsiveData(
        deviceType: DeviceType.mobile,
        screenWidth: 400,
        screenHeight: 800,
        child: SizedBox(),
      );
      const tabletData = ResponsiveData(
        deviceType: DeviceType.tablet,
        screenWidth: 700,
        screenHeight: 600,
        child: SizedBox(),
      );
      const desktopData = ResponsiveData(
        deviceType: DeviceType.desktop,
        screenWidth: 1024,
        screenHeight: 768,
        child: SizedBox(),
      );

      expect(mobileData.isTabletOrDesktop, isFalse);
      expect(tabletData.isTabletOrDesktop, isTrue);
      expect(desktopData.isTabletOrDesktop, isTrue);
    });
  });

  group('ResponsiveSpacing', () {
    test('small returns correct values', () {
      expect(ResponsiveSpacing.small(DeviceType.mobile), 8);
      expect(ResponsiveSpacing.small(DeviceType.tablet), 12);
      expect(ResponsiveSpacing.small(DeviceType.desktop), 16);
    });

    test('medium returns correct values', () {
      expect(ResponsiveSpacing.medium(DeviceType.mobile), 16);
      expect(ResponsiveSpacing.medium(DeviceType.tablet), 24);
      expect(ResponsiveSpacing.medium(DeviceType.desktop), 32);
    });

    test('large returns correct values', () {
      expect(ResponsiveSpacing.large(DeviceType.mobile), 24);
      expect(ResponsiveSpacing.large(DeviceType.tablet), 40);
      expect(ResponsiveSpacing.large(DeviceType.desktop), 60);
    });

    test('extraLarge returns correct values', () {
      expect(ResponsiveSpacing.extraLarge(DeviceType.mobile), 40);
      expect(ResponsiveSpacing.extraLarge(DeviceType.tablet), 60);
      expect(ResponsiveSpacing.extraLarge(DeviceType.desktop), 80);
    });
  });

  group('ResponsiveFontSize', () {
    test('headlineLarge returns correct values', () {
      expect(ResponsiveFontSize.headlineLarge(DeviceType.mobile), 24);
      expect(ResponsiveFontSize.headlineLarge(DeviceType.tablet), 32);
      expect(ResponsiveFontSize.headlineLarge(DeviceType.desktop), 40);
    });

    test('headlineMedium returns correct values', () {
      expect(ResponsiveFontSize.headlineMedium(DeviceType.mobile), 18);
      expect(ResponsiveFontSize.headlineMedium(DeviceType.tablet), 24);
      expect(ResponsiveFontSize.headlineMedium(DeviceType.desktop), 28);
    });

    test('headlineSmall returns correct values', () {
      expect(ResponsiveFontSize.headlineSmall(DeviceType.mobile), 14);
      expect(ResponsiveFontSize.headlineSmall(DeviceType.tablet), 16);
      expect(ResponsiveFontSize.headlineSmall(DeviceType.desktop), 20);
    });

    test('body returns correct values', () {
      expect(ResponsiveFontSize.body(DeviceType.mobile), 10);
      expect(ResponsiveFontSize.body(DeviceType.tablet), 12);
      expect(ResponsiveFontSize.body(DeviceType.desktop), 14);
    });

    test('caption returns correct values', () {
      expect(ResponsiveFontSize.caption(DeviceType.mobile), 8);
      expect(ResponsiveFontSize.caption(DeviceType.tablet), 10);
      expect(ResponsiveFontSize.caption(DeviceType.desktop), 12);
    });
  });

  group('ResponsiveValue', () {
    test('resolve returns correct value for each device type', () {
      const value = ResponsiveValue<int>(
        mobile: 1,
        tablet: 2,
        desktop: 3,
      );

      expect(value.resolve(DeviceType.mobile), 1);
      expect(value.resolve(DeviceType.tablet), 2);
      expect(value.resolve(DeviceType.desktop), 3);
    });

    test('resolve falls back to mobile when tablet is null', () {
      const value = ResponsiveValue<int>(
        mobile: 1,
      );

      expect(value.resolve(DeviceType.tablet), 1);
    });

    test('resolve falls back to tablet when desktop is null', () {
      const value = ResponsiveValue<int>(
        mobile: 1,
        tablet: 2,
      );

      expect(value.resolve(DeviceType.desktop), 2);
    });

    test(
      'resolve falls back to mobile when both tablet and desktop are null',
      () {
        const value = ResponsiveValue<int>(
          mobile: 1,
        );

        expect(value.resolve(DeviceType.desktop), 1);
      },
    );
  });

  group('Breakpoints', () {
    test('compact is 600', () {
      expect(Breakpoints.compact, 600);
    });

    test('expanded is 840', () {
      expect(Breakpoints.expanded, 840);
    });
  });
}
