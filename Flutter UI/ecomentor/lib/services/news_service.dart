import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/news.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'news';

  // Get latest news with pagination
  Stream<List<News>> getLatestNews(
      {int limit = 10, DocumentSnapshot? lastDocument}) {
    Query query = _firestore
        .collection(_collection)
        .where('summary', isNotEqualTo: '')
        .orderBy('summary')
        .orderBy('publishedDate', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return News.fromJson(data);
      }).toList();
    });
  }

  // Toggle bookmark status
  Future<void> toggleBookmark(String newsId, bool isBookmarked) async {
    await _firestore
        .collection(_collection)
        .doc(newsId)
        .update({'isBookmarked': isBookmarked});
  }

  // Get bookmarked news
  Stream<List<News>> getBookmarkedNews() {
    return _firestore
        .collection(_collection)
        .where('isBookmarked', isEqualTo: true)
        .where('summary', isNotEqualTo: '')
        .orderBy('summary')
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return News.fromJson(data);
      }).toList();
    });
  }

  // Search news by tags or content
  Future<List<News>> searchNews(String query) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('summary', isNotEqualTo: '')
        .where('tags', arrayContains: query.toLowerCase())
        .orderBy('summary')
        .orderBy('publishedDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return News.fromJson(data);
    }).toList();
  }
}
