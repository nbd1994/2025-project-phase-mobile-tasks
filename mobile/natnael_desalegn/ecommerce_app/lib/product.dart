import 'home_page.dart';

class Product{
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;
  Product(this.name, this.image, this.price, this.category, this.description);
}



List<Product> products = [
  Product('Nike Casual Mens', 'assets/images/shoes.jpg', 120, 'Mens', Utils().dummyText()),
  Product('Air Jordan', 'assets/images/shoes2.jpg', 200, 'Mens', Utils().dummyText()),
];