import 'package:friends_around_me/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:friends_around_me/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:friends_around_me/ui/views/home/home_view.dart';
import 'package:friends_around_me/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:friends_around_me/services/firebase_core_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    AdaptiveRoute(page: StartupView, initial: true),
    AdaptiveRoute(page: HomeView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    InitializableSingleton(classType: FirebaseCoreService),
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
