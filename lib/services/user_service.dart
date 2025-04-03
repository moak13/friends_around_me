import 'package:friends_around_me/app/app.locator.dart';
import 'package:friends_around_me/app/app.logger.dart';
import 'package:friends_around_me/data_models/user_data_model.dart';
import 'package:friends_around_me/exceptions/app_exception.dart';
import 'package:friends_around_me/services/firestore_service.dart';

class UserService {
  final _logger = getLogger('UserService');
  final _firestoreService = locator<FirestoreService>();

  Future<void> createUser({
    UserDataModel? user,
  }) async {
    try {
      await _firestoreService.post(
        path: 'users/${user?.id}',
        data: user!.toJson(),
      );
    } catch (e, s) {
      _logger.e(
        'error trying to create a user',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to create user data',
        devDetails: e.toString(),
      );
    }
  }

  Future<UserDataModel?> fetchUser({
    String? uid,
  }) async {
    try {
      final response = await _firestoreService.get<UserDataModel?>(
        path: 'users/$uid',
        builder: (json) => UserDataModel.fromJson(json),
      );

      return response;
    } catch (e, s) {
      _logger.e(
        'error trying to fetch a user',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to fetch user data',
        devDetails: e.toString(),
      );
    }
  }

  Future<void> updateUser({
    UserDataModel? user,
  }) async {
    try {
      await _firestoreService.patch(
        path: 'users/${user?.id}',
        data: user!.toJson(),
      );
    } catch (e, s) {
      _logger.e(
        'error trying to update a user',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to update user data',
        devDetails: e.toString(),
      );
    }
  }

  Future<void> deleteUser({
    String? uid,
  }) async {
    try {
      await _firestoreService.delete(
        path: 'users/$uid',
      );
    } catch (e, s) {
      _logger.e(
        'error trying to delete a user',
        error: e,
        stackTrace: s,
      );
      throw AppException(
        message: 'Failed to delete user data',
        devDetails: e.toString(),
      );
    }
  }
}
