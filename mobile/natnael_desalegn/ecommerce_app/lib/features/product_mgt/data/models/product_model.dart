import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.description,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> jsn) {
    return ProductModel(
      id: jsn['id'],
      name: jsn['name'],
      price: jsn['price'],
      imageUrl: jsn['imageUrl'],
      category: jsn['category'],
      description: jsn['description'],
      rating: jsn['rating'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'rating': rating,
    };
  }
}
