import '../models/product_model.dart';

abstract class ProductMgtLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();

  //this should be replacing the existing cache or creating new cache 
  Future<void> cacheProducts(List<ProductModel> pdts);

  //this should be update or create type of implementation
  Future<void> cacheSingleProduct(ProductModel pdt);

  //this should delete if the product exists
  Future<void> deleteCachedProduct(ProductModel pdt);

  Future<ProductModel> getCachedSingleProduct(int id);
}