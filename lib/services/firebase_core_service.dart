import 'package:firebase_core/firebase_core.dart';
import 'package:friends_around_me/app/app.logger.dart';
import 'package:friends_around_me/firebase_options.dart';

class FirebaseCoreService {
  final _logger = getLogger('FirebaseCoreService');
  Future<void> init() async {
    try {
      _logger.i('Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _logger.i('Firebase initialized successfully');
    } catch (e, s) {
      _logger.e('Error initializing Firebase', e, s);
    }
  }
}
