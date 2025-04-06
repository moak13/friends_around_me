import 'package:friends_around_me/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:friends_around_me/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:friends_around_me/ui/views/home/home_view.dart';
import 'package:friends_around_me/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:friends_around_me/services/firebase_core_service.dart';
import 'package:friends_around_me/services/firestore_service.dart';
import 'package:friends_around_me/services/user_service.dart';
import 'package:friends_around_me/services/local_location_service.dart';
import 'package:friends_around_me/services/remote_location_service.dart';
import 'package:friends_around_me/ui/views/signup/signup_view.dart';
import 'package:friends_around_me/ui/views/signin/signin_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    AdaptiveRoute(page: StartupView, initial: true),
    AdaptiveRoute(page: SignupView),
    AdaptiveRoute(page: SigninView),
    AdaptiveRoute(page: HomeView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    InitializableSingleton(classType: FirebaseCoreService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: LocalLocationService),
    LazySingleton(classType: RemoteLocationService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
