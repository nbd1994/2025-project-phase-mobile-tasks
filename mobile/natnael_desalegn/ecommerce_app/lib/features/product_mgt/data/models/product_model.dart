import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> jsn) {
    return ProductModel(
      id: jsn['id'],
      name: jsn['name'],
      price: jsn['price'],
      imageUrl: jsn['imageUrl'],
      description: jsn['description'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
