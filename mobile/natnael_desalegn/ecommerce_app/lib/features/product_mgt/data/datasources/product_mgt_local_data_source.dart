import '../models/product_model.dart';

abstract class ProductMgtLocalDataSource {
  Future<void> deleteProduct(int id);
  Future<ProductModel> getProduct(int id);
  Future<ProductModel> insertProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
}