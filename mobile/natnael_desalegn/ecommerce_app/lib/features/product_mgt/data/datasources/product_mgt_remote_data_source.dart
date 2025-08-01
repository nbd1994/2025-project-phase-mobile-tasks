import '../models/product_model.dart';

abstract class ProductMgtRemoteDataSource {
  Future<ProductModel> deleteProduct(int id);
  Future<ProductModel> getProduct(int id);
  Future<ProductModel> insertProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<List<ProductModel>> getAllProducts();
}