import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends_around_me/app/app.logger.dart';

class FirestoreService {
  final _logger = getLogger('FirestoreService');
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> post({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = _firebaseFirestore.doc(path);
      await reference.set(data);
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  Future<T?> get<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) async {
    try {
      final reference = _firebaseFirestore.doc(path);
      final snapshot = await reference.get();
      final data = snapshot.data();
      return builder(data!);
    } catch (e, s) {
      _handleError(e, s);
      return Future.value(null);
    }
  }

  Future<void> delete({
    required String path,
  }) async {
    try {
      final reference = _firebaseFirestore.doc(path);
      await reference.delete();
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  Future<void> patch({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = _firebaseFirestore.doc(path);
      await reference.update(data);
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  Stream<T?> streamDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    try {
      final reference = _firebaseFirestore.doc(path);
      final Stream<DocumentSnapshot> snapshots = reference.snapshots();
      return snapshots.map((snapshot) {
        if (!snapshot.exists) return null;
        return builder(snapshot.data() as Map<String, dynamic>);
      });
    } catch (e, s) {
      _handleError(e, s);
      return Stream.value(null);
    }
  }

  Stream<List<T>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    try {
      Query query = _firebaseFirestore.collection(path);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }

      final Stream<QuerySnapshot> snapshots = query.snapshots();
      return snapshots.map((snapshot) {
        final result = snapshot.docs
            .map((doc) => builder(doc.data() as Map<String, dynamic>))
            .toList();

        if (sort != null) {
          result.sort(sort);
        }

        return result;
      });
    } catch (e, s) {
      _handleError(e, s);
      return Stream.value([]);
    }
  }

  _handleError(dynamic e, StackTrace s) {
    _logger.e(
      'Operation failed with this error and stacktrace',
      error: e,
      stackTrace: s,
    );
    throw e;
  }
}
