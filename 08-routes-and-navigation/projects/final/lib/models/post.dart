class Post {
  String id;
  String profileImageUrl;
  String comment;
  String timestamp;

  Post(
    this.id,
    this.profileImageUrl,
    this.comment,
    this.timestamp,
  );

}

List<Post> posts = [
  Post('1', '',
      'Just booked my flights to Tokyo! Found a great deal.', '10'),
  Post('2', '',
      'Reached my savings goal for the year. Time for a vacation!', '80'),
  Post('3', '',
      'Exploring the Swiss Alps. The view is worth every penny.', '20'),
  Post('4', '',
      'Budgeted for the next 6 months. Feeling organized.', '30'),
  Post(
      '5',
      '',
      '''Checking out some investment options for my retirement fund.''',
      '40'),
  Post(
      '6',
      '',
      '''Found a hidden gem in Paris. Best dinner of the trip!''',
      '50'),
  Post(
      '7',
      '',
      '''Tracking all my expenses this week. Surprised by how much I spend on coffee!''',
      '50'),
  Post('8', '',
      'Deciding between Italy or Spain for my next adventure.', '60'),
  Post('9', '',
      'New travel gear arrived. Ready for the next flight!', '70'),
  Post('10', '',
      'Hotel booked for the weekend getaway. Can\'t wait!', '90'),
];
