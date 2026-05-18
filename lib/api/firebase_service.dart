import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // --- Reviews ---
  Future<void> addReview(String destinationId, String comment, double rating) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final review = Review(
      destinationId: destinationId,
      userId: user.uid,
      userName: user.email?.split('@').first ?? 'User',
      comment: comment,
      rating: rating,
      timestamp: DateTime.now(),
    );

    await _db.collection('destinations').doc(destinationId).collection('reviews').add(review.toFirestore());
  }

  Stream<List<Review>> getReviews(String destinationId) {
    return _db
        .collection('destinations')
        .doc(destinationId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  // --- Favorites ---
  Future<void> toggleFavorite(String destinationId) async {
    final uid = userId;
    if (uid == null) return;

    final docRef = _db.collection('users').doc(uid).collection('favorites').doc(destinationId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'destinationId': destinationId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<List<String>> watchFavorites() {
    final uid = userId;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // --- Orders ---
  Future<void> saveOrder(ActivityOrder order) async {
    final uid = userId;
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('orders').add({
      'name': order.name,
      'totalCost': order.totalCost,
      'date': order.selectedDate != null ? Timestamp.fromDate(order.selectedDate!) : FieldValue.serverTimestamp(),
      'time': order.getFormattedTime(),
      'segment': order.getFormattedSegment(),
      'items': order.items.map((item) => {
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      }).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getOrderHistory() {
    final uid = userId;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList());
  }
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

final favoritesProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(firebaseServiceProvider).watchFavorites();
});
