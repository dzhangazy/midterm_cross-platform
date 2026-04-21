class FoodCategory {
  String name;
  int numberOfItems;
  String imageUrl;

  FoodCategory(this.name, this.numberOfItems, this.imageUrl);
}

List<FoodCategory> categories = [
  FoodCategory('Flights', 16, 'assets/categories/flights.png'),
  FoodCategory('Hotels', 20, 'assets/categories/hotels.png'),
  FoodCategory('Dining', 21, 'assets/categories/dining.png'),
  FoodCategory('Transport', 16, 'assets/categories/transport.png'),
  FoodCategory('Shopping', 18, 'assets/categories/shopping.png'),
  FoodCategory('Leisure', 15, 'assets/categories/leisure.png'),
  FoodCategory('Savings', 14, 'assets/categories/savings.png'),
  FoodCategory('Investment', 19, 'assets/categories/investment.png'),
  FoodCategory('Insurance', 15, 'assets/categories/insurance.png'),
  FoodCategory('Entertainment', 22, 'assets/categories/entertainment.png'),
  FoodCategory('Bills', 23, 'assets/categories/bills.png'),
  FoodCategory('Miscellaneous', 18, 'assets/categories/misc.png'),
];
