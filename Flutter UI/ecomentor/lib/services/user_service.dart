import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Create new user
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  // Get user by ID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }

  // Update user
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(uid).update(data);
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  // Update user points
  Future<void> updatePoints(String uid, int points) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'points': FieldValue.increment(points),
      });
    } catch (e) {
      throw 'Failed to update points: $e';
    }
  }

  // Add completed course
  Future<void> addCompletedCourse(String uid, String courseId) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'completedCourses': FieldValue.arrayUnion([courseId]),
        'inProgressCourses': FieldValue.arrayRemove([courseId]),
      });
    } catch (e) {
      throw 'Failed to add completed course: $e';
    }
  }

  // Add course in progress
  Future<void> addCourseInProgress(String uid, String courseId) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'inProgressCourses': FieldValue.arrayUnion([courseId]),
      });
    } catch (e) {
      throw 'Failed to add course in progress: $e';
    }
  }

  // Add badge
  Future<void> addBadge(String uid, String badgeId) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'badges': FieldValue.arrayUnion([badgeId]),
      });
    } catch (e) {
      throw 'Failed to add badge: $e';
    }
  }

  // Stream user data
  Stream<UserModel> streamUser(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data()!, uid));
  }
}
