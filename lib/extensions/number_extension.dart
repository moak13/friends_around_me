import 'package:friends_around_me/ui/common/device_scaler.dart';

extension NumScaler on num {
  double get sh => DeviceScaler().scaleHeight(toDouble());
  double get sw => DeviceScaler().scaleWidth(toDouble());
  double get sf => DeviceScaler().scaleFont(toDouble());
}
