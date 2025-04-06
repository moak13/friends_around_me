import 'package:friends_around_me/app/app.locator.dart';
import 'package:friends_around_me/data_models/user_location_data_model.dart';
import 'package:friends_around_me/enum/location_permission_status.dart';
import 'package:friends_around_me/services/local_location_service.dart';
import 'package:friends_around_me/services/remote_location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class MapViewModel extends StreamViewModel<List<UserLocationDataModel>> {
  final _localLocationService = locator<LocalLocationService>();
  final _remoteLocationService = locator<RemoteLocationService>();
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();

  LocationPermissionStatus? get status =>
      _localLocationService.locationPermissionStatus;
  UserLocationDataModel? get currentUserLocation =>
      _remoteLocationService.currentUserLocation;

  @override
  Stream<List<UserLocationDataModel>> get stream {
    final userId = _firebaseAuthenticationService.currentUser?.uid;
    return _remoteLocationService.getAllOtherUsersLocations(
      userId: userId ?? '',
    );
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _localLocationService,
        _remoteLocationService,
      ];
}
