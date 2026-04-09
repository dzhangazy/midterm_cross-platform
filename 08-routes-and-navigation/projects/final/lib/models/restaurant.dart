class Item {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Restaurant {
  String id;
  String name;
  String address;
  String attributes;
  String imageUrl;
  String imageCredits;
  double distance;
  double rating;
  List<Item> items;

  Restaurant(
    this.id, 
    this.name, 
    this.address,
    this.attributes, 
    this.imageUrl, 
    this.imageCredits,
    this.distance, 
    this.rating, 
    this.items);

  String getRatingAndDistance() {
    return '''Rating: ${rating.toStringAsFixed(1)} ★ | Distance: ${distance.toStringAsFixed(1)} miles''';
  }
}

List<Restaurant> restaurants = [
  Restaurant(
    '0',
    'Alpine Escape',
    'Swiss Alps, Zermatt',
    'Skiing, Spa, Luxury',
    'assets/trips/alpine_escape.webp',
    'Unsplash',
    2500,
    4.9, 
    [
    Item(
      name: 'Ski Pass',
      description: 'Full day access to all Matterhorn glacier paradise lifts.',
      price: 85.00,
      imageUrl: 'assets/activities/ski_pass.webp',
    ),
    Item(
      name: 'Mountain Guide',
      description: 'Professional guide for off-piste exploration.',
      price: 150.00,
      imageUrl: 'assets/activities/mountain_guide.webp',
    ),
    Item(
      name: 'Fondue Dinner',
      description: 'Traditional Swiss cheese fondue with local wine.',
      price: 45.00,
      imageUrl: 'assets/activities/fondue_dinner.webp',
    ),
  ]),
  Restaurant(
    '1',
      "Tokyo Metro Explorer",
      'Shibuya, Tokyo, Japan',
      'Urban, Cultural, Tech',
      'assets/trips/tokyo_explorer.webp',
      'Unsplash',
      6000,
      4.8, [
    Item(
      name: 'JR Pass 7-Day',
      description: 'Unlimited travel on all JR national trains including Shinkansen.',
      price: 280.00,
      imageUrl:'assets/activities/jr_pass.webp',
    ),
    Item(
      name: 'Robot Restaurant Ticket',
      description: 'Entrance fee for the famous Shinjuku robot show.',
      price: 75.00,
      imageUrl: 'assets/activities/robot_show.webp',
    ),
    Item(
      name: 'Sushi Making Class',
      description: 'Learn to make authentic sushi from a master chef at Tsukiji.',
      price: 60.00,
      imageUrl: 'assets/activities/sushi_class.webp',
    ),
  ]),
  Restaurant(
    '2',
      'Parisian Romance',
      'Champs-Élysées, Paris, France',
      'Museums, Art, Fine Dining',
      'assets/trips/parisian_romance.webp',
      'Unsplash',
      3500,
      4.7, [
    Item(
      name: 'Louvre Museum Entry',
      description: 'Fast-track entry to the world\'s largest art museum.',
      price: 22.00,
      imageUrl: 'assets/activities/louvre.webp'
    ),
    Item(
      name: 'Seine River Cruise',
      description: 'Romantic evening cruise with views of the Eiffel Tower.',
      price: 18.00,
      imageUrl: 'assets/activities/river_cruise.webp'
    ),
    Item(
      name: 'Eiffel Tower Summit Access',
      description: 'Lift ticket to the top of the Eiffel Tower.',
      price: 26.00,
      imageUrl: 'assets/activities/eiffel_tower.webp'
    ),
  ]),
];
