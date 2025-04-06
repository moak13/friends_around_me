import 'package:friends_around_me/app/app.locator.dart';
import 'package:friends_around_me/app/app.logger.dart';
import 'package:friends_around_me/app/app.router.dart';
import 'package:friends_around_me/data_models/user_data_model.dart';
import 'package:friends_around_me/exceptions/app_exception.dart';
import 'package:friends_around_me/extensions/string_extension.dart';
import 'package:friends_around_me/services/user_service.dart';
import 'package:friends_around_me/ui/views/signup/signup_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends FormViewModel {
  final _logger = getLogger('SignupViewModel');
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _userService = locator<UserService>();

  Future<void> submit() async {
    setBusy(true);
    try {
      final response =
          await _firebaseAuthenticationService.createAccountWithEmail(
        email: emailValue ?? '',
        password: passwordValue ?? '',
      );

      if (response.hasError && response.user == null) {
        final errorMessage = response.errorMessage;
        _logger.w(errorMessage);
        _dialogService.showDialog(
          title: 'Error',
          description: errorMessage,
        );
        return;
      }

      if (!response.hasError && response.user == null) {
        _logger.f(
            'We have no error but the user is null. This should not be happening');
        _dialogService.showDialog(
          title: 'Opps',
          description: 'Unknown Error',
        );
        return;
      }

      final nameParts = fullNameValue?.nameParts;
      final firstName = nameParts?.first;
      final lastName = nameParts?.last;

      UserDataModel user = UserDataModel(
        id: response.user?.uid ?? '',
        email: response.user?.email ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
      );

      await _userService.createUser(
        user: user,
      );

      await _userService.fetchUser(
        uid: response.user?.uid ?? '',
      );

      _navigationService.clearStackAndShow(Routes.mapView);
    } on AppException catch (e) {
      final errorMessage = e.message;
      _logger.e(
        errorMessage,
        error: e,
      );

      _dialogService.showDialog(
        title: 'Error',
        description: errorMessage,
      );
    } catch (e, s) {
      const errorMessage = 'Unknown Error';

      _logger.e(
        errorMessage,
        error: e,
        stackTrace: s,
      );

      _dialogService.showDialog(
        title: 'Opps',
        description: errorMessage,
      );
    } finally {
      setBusy(false);
    }
  }
}
