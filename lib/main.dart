import 'package:flutter/material.dart';
import 'package:friends_around_me/app/app.bottomsheets.dart';
import 'package:friends_around_me/app/app.dialogs.dart';
import 'package:friends_around_me/app/app.locator.dart';
import 'package:friends_around_me/app/app.router.dart';
import 'package:friends_around_me/ui/common/device_scaler.dart';
import 'package:friends_around_me/utils/context_util.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ContextUtil.hideKeyboard(context),
      child: MaterialApp(
        title: 'Friends Around Me',
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: [
          StackedService.routeObserver,
        ],
        builder: (context, child) {
          final mQuery = MediaQuery.of(context);
          DeviceScaler().deviceHeight = mQuery.size.height;
          DeviceScaler().deviceWidth = mQuery.size.width;

          return MediaQuery(
            data: mQuery.copyWith(
              textScaler: MediaQuery.textScalerOf(context).clamp(
                maxScaleFactor: 1.4,
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
