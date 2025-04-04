import 'dart:async';

import 'package:friends_around_me/app/app.logger.dart';
import 'package:friends_around_me/enum/location_permission_status.dart';
import 'package:friends_around_me/exceptions/app_exception.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';

class LocalLocationService with ListenableServiceMixin {
  final _logger = getLogger('LocalLocationService');

  LocalLocationService() {
    listenToReactiveValues([locationPermissionStatus]);
  }

  ReactiveValue<LocationPermissionStatus?> locationPermissionStatus =
      ReactiveValue<LocationPermissionStatus?>(null);

  LocationPermissionStatus? get locationPermissionStatusValue =>
      locationPermissionStatus.value;

  final _positionStreamController = StreamController<Position?>.broadcast();

  Stream<Position?> get positionStream => _positionStreamController.stream;

  StreamSubscription<Position>? _positionStreamSubscription;

  Future<LocationPermissionStatus> checkLocationPermissionStatus() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logger.w('Location services are disabled.');
        locationPermissionStatus.value =
            LocationPermissionStatus.serviceDisabled;
        return LocationPermissionStatus.serviceDisabled;
      }

      // Check permission status
      final permission = await Geolocator.checkPermission();

      LocationPermissionStatus status;
      switch (permission) {
        case LocationPermission.denied:
          status = LocationPermissionStatus.denied;
          break;
        case LocationPermission.deniedForever:
          status = LocationPermissionStatus.deniedForever;
          break;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          status = LocationPermissionStatus.granted;
          break;
        case LocationPermission.unableToDetermine:
          status = LocationPermissionStatus.unknown;
          break;
      }

      locationPermissionStatus.value = status;
      return status;
    } catch (e, s) {
      _logger.e(
        'Error checking permission status',
        error: e,
        stackTrace: s,
      );
      return LocationPermissionStatus.unknown;
    }
  }

  Future<LocationPermissionStatus> requestLocationPermission() async {
    try {
      var status = await checkLocationPermissionStatus();

      if (status == LocationPermissionStatus.serviceDisabled) {
        return LocationPermissionStatus.serviceDisabled;
      }

      if (status == LocationPermissionStatus.denied) {
        final permission = await Geolocator.requestPermission();
        status = _convertPermissionToStatus(permission);
      }

      if (status == LocationPermissionStatus.deniedForever) {
        return LocationPermissionStatus.deniedForever;
      }

      locationPermissionStatus.value = status;
      return status;
    } catch (e, s) {
      _logger.e(
        'Error requesting permissions',
        error: e,
        stackTrace: s,
      );
      return LocationPermissionStatus.unknown;
    }
  }

  LocationPermissionStatus _convertPermissionToStatus(
      LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unknown;
    }
  }

  // Get current position continuously
  Future<void> startLocationStream() async {
    try {
      final status = await requestLocationPermission();

      if (status != LocationPermissionStatus.granted) {
        throw AppException(
          message: 'Location permissions not granted: $status',
        );
      }

      await stopLocationStream();

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(
        (position) => _positionStreamController.add(position),
        onError: (e) {
          _logger.e(
            'Location stream error',
            error: e,
          );
          _positionStreamController.addError(e);
          _positionStreamSubscription = null;
        },
      );
    } catch (e, s) {
      _logger.e('Error starting location stream', error: e, stackTrace: s);
      rethrow;
    }
  }

  // Stop streaming
  Future<void> stopLocationStream() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _positionStreamController.add(null);
  }

  // Get current position once
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e, s) {
      _logger.e(
        'Error getting current position',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  // To allow the user to enable location services
  Future<void> openLocationSettings() async {
    try {
      final enabled = await Geolocator.openLocationSettings();
      if (!enabled) {
        locationPermissionStatus.value =
            LocationPermissionStatus.serviceDisabled;
        return;
      }
      final status = await checkLocationPermissionStatus();
      locationPermissionStatus.value = status;
    } catch (e, s) {
      locationPermissionStatus.value = LocationPermissionStatus.unknown;
      _logger.e(
        'Error opening location settings',
        error: e,
        stackTrace: s,
      );
    }
  }

  // Open app settings
  // to allow the user to enable location permissions
  // or denied forever
  Future<void> openAppSettings() async {
    try {
      final enabled = await Geolocator.openAppSettings();
      if (!enabled) {
        locationPermissionStatus.value = LocationPermissionStatus.deniedForever;
        return;
      }
      final status = await checkLocationPermissionStatus();
      locationPermissionStatus.value = status;
    } catch (e, s) {
      locationPermissionStatus.value = LocationPermissionStatus.unknown;
      _logger.e(
        'Error opening app settings',
        error: e,
        stackTrace: s,
      );
    }
  }

  // Dispose of the stream controller
  // and stop the location stream
  Future<void> dispose() async {
    await stopLocationStream();
    if (!_positionStreamController.isClosed) {
      await _positionStreamController.close();
    }
  }
}
