import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id;
  final String destinationId;
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime timestamp;

  Review({
    this.id,
    required this.destinationId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Review(
      id: doc.id,
      destinationId: data['destinationId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'Anonymous',
      comment: data['comment'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'destinationId': destinationId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
