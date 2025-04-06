import 'dart:math';

/// Proportionally scale vertical dimensions and fonts up and/or down depending
/// on a device's screen height
class DeviceScaler {
  double? deviceHeight;
  double? deviceWidth;

  static final DeviceScaler _instance = DeviceScaler._privateConstructor();
  DeviceScaler._privateConstructor();

  factory DeviceScaler() => _instance;

  /// Design dimensions
  static const double _referenceHeight = 812;
  static const double _referenceWidth = 375;

  /// [minSize] This is the least height dimension you don't want to go below
  /// [canScaleUp] Set to false if you don't want to scale above the [referenceSize]
  /// [referenceSize] The size dimension you want to scale up or/and down.
  double scaleHeight(
    double referenceSize, {
    double? minSize,
    bool? canScaleUp = true,
  }) {
    if (deviceHeight == null) {
      return referenceSize;
    }

    double ratio = deviceHeight! / _referenceHeight;

    final scaledSize = (ratio * referenceSize).ceilToDouble();

    if (canScaleUp != null && !canScaleUp && scaledSize > referenceSize) {
      return referenceSize;
    }

    if (minSize == null) {
      return scaledSize;
    }

    return max(minSize, scaledSize);
  }

  /// [minSize] This is the least width dimension you don't want to go below
  /// [canScaleUp] Set to false if you don't want to scale above the [referenceSize]
  /// [referenceSize] The size dimension you want to scale up or/and down.
  double scaleWidth(
    double referenceSize, {
    double? minSize,
    bool? canScaleUp = true,
  }) {
    if (deviceWidth == null) {
      return referenceSize;
    }

    double ratio = deviceWidth! / _referenceWidth;

    final scaledSize = (ratio * referenceSize).ceilToDouble();

    if (canScaleUp != null && !canScaleUp && scaledSize > referenceSize) {
      return referenceSize;
    }

    if (minSize == null) {
      return scaledSize;
    }

    return max(minSize, scaledSize);
  }

  /// Font scaling is constrained to 10pt as the least size attainable
  /// Use this to scale fonts
  double scaleFont(
    double referenceSize, {
    bool? canScaleUp = true,
  }) {
    return scaleHeight(
      referenceSize,
      minSize: 10,
      canScaleUp: canScaleUp,
    );
  }
}
