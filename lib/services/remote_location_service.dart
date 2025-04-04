import 'dart:async';

import 'package:friends_around_me/app/app.locator.dart';
import 'package:friends_around_me/app/app.logger.dart';
import 'package:friends_around_me/data_models/user_location_data_model.dart';
import 'package:friends_around_me/exceptions/app_exception.dart';
import 'package:stacked/stacked.dart';

import 'firestore_service.dart';
import 'local_location_service.dart';

class RemoteLocationService with ListenableServiceMixin {
  final _logger = getLogger('RemoteLocationService');
  final _firestoreService = locator<FirestoreService>();
  final _localLocationService = locator<LocalLocationService>();

  RemoteLocationService() {
    listenToReactiveValues([
      _isTracking,
      _currentUserLocation,
      _allOtherUsersLocations,
    ]);
  }

  final ReactiveValue<bool> _isTracking = ReactiveValue(false);
  final ReactiveValue<UserLocationDataModel?> _currentUserLocation =
      ReactiveValue(null);
  final ReactiveValue<List<UserLocationDataModel>> _allOtherUsersLocations =
      ReactiveValue([]);

  bool get isTracking => _isTracking.value;
  UserLocationDataModel? get currentUserLocation => _currentUserLocation.value;
  List<UserLocationDataModel> get allOtherUsersLocations =>
      _allOtherUsersLocations.value;

  StreamSubscription<UserLocationDataModel?>? _positionSubscription;

  Future<void> createUserLocation({
    required UserLocationDataModel userLocation,
  }) async {
    try {
      final id = await _firestoreService.post(
        path: 'locations',
        data: userLocation.toJson(),
      );

      if (id != null) {
        final updatedUserLocation = userLocation.copyWith(
          id: id,
        );
        await _updateUserLocation(
          updatedUserLocation: updatedUserLocation,
        );
      }
    } catch (e, s) {
      _logger.e(
        'error trying to create a user location',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to create user location data',
        devDetails: e.toString(),
      );
    }
  }

  Future<UserLocationDataModel?> fetchUserLocation({
    required String userId,
  }) async {
    try {
      final response = await _firestoreService.getFirst<UserLocationDataModel?>(
        path: 'locations',
        queryBuilder: (query) {
          return query.where(
            'userId',
            isEqualTo: userId,
          );
        },
        builder: (json) => UserLocationDataModel.fromJson(json),
      );

      _currentUserLocation.value = response;

      _logger
          .i('current user location: ${_currentUserLocation.value?.toJson()}');

      return response;
    } catch (e, s) {
      _logger.e(
        'error trying to fetch a user location',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to fetch user location data',
        devDetails: e.toString(),
      );
    }
  }

  Future<void> _updateUserLocation({
    required UserLocationDataModel updatedUserLocation,
  }) async {
    try {
      await _firestoreService.patch(
        path: 'locations/${updatedUserLocation.id}',
        data: updatedUserLocation.toJson(),
      );
    } catch (e, s) {
      _logger.e(
        'error trying to update user location',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to update user location data',
        devDetails: e.toString(),
      );
    }
  }

  // Start tracking the user's location
  Future<void> startTracking() async {
    try {
      if (_isTracking.value) return;

      _isTracking.value = true;

      // Start local location stream
      await _localLocationService.startLocationStream();

      // Subscribe to position updates
      _positionSubscription =
          _localLocationService.positionStream.listen((position) async {
        if (position == null) return;

        final userLocation = _currentUserLocation.value;

        final updatedUserLocation = userLocation?.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        if (updatedUserLocation != null) {
          _currentUserLocation.value = updatedUserLocation;
          await _updateUserLocation(
            updatedUserLocation: updatedUserLocation,
          );
        }
      }, onError: (e) {
        _logger.e(
          'Location stream error',
          error: e,
        );
        stopTracking();
      });
    } catch (e, s) {
      _logger.e(
        'Error starting tracking',
        error: e,
        stackTrace: s,
      );
      _isTracking.value = false;
      throw AppException(
        message: 'Failed to start tracking user location',
        devDetails: e.toString(),
      );
    }
  }

  // Stop tracking with proper cleanup
  Future<void> stopTracking() async {
    try {
      _isTracking.value = false;
      await _localLocationService.stopLocationStream();
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      _currentUserLocation.value = null;
    } catch (e, s) {
      _logger.e(
        'Error stopping tracking',
        error: e,
        stackTrace: s,
      );

      throw AppException(
        message: 'Failed to stop tracking user location',
        devDetails: e.toString(),
      );
    }
  }

  // Initialize all other users' locations stream
  Stream<List<UserLocationDataModel>> getAllOtherUsersLocations({
    required String userId,
  }) {
    try {
      return _firestoreService
          .streamCollection<UserLocationDataModel>(
        path: 'locations',
        queryBuilder: (query) => query.where(
          'userId',
          isNotEqualTo: userId,
        ),
        builder: (json) => UserLocationDataModel.fromJson(json),
      )
          .map((locations) {
        _allOtherUsersLocations.value = locations;
        return locations;
      });
    } catch (e, s) {
      _logger.e(
        'Error fetching all other users locations',
        error: e,
        stackTrace: s,
      );

      throw AppException(
        message: 'Failed to fetch all other users locations',
        devDetails: e.toString(),
      );
    }
  }
}
