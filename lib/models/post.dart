class Post {
  final String id;
  final String author;
  final String authorEmail;
  final String profileImageUrl;
  final String comment;
  final String timestamp;

  Post({
    required this.id,
    required this.author,
    required this.authorEmail,
    required this.profileImageUrl,
    required this.comment,
    required this.timestamp,
  });
}

List<Post> posts = [
  Post(
    id: '1',
    author: 'Stef P.',
    authorEmail: 'stef@yummy.com',
    profileImageUrl: '',
    comment: 'Just booked my flights to Tokyo! Found a great deal.',
    timestamp: '10',
  ),
  Post(
    id: '2',
    author: 'Kim A.',
    authorEmail: 'kim@yummy.com',
    profileImageUrl: '',
    comment: 'Reached my savings goal for the year. Time for a vacation!',
    timestamp: '80',
  ),
  Post(
    id: '3',
    author: 'Steve H.',
    authorEmail: 'steve@yummy.com',
    profileImageUrl: '',
    comment: 'Exploring the Swiss Alps. The view is worth every penny.',
    timestamp: '20',
  ),
  Post(
    id: '4',
    author: 'Emily L.',
    authorEmail: 'emily@yummy.com',
    profileImageUrl: '',
    comment: 'Budgeted for the next 6 months. Feeling organized.',
    timestamp: '30',
  ),
];
