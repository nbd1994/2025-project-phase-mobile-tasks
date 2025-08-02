import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../product.dart';
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

// ignore: constant_identifier_names
const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

// helper functions
List<ProductModel> _decodeProducts(String? jsonString) {
  if (jsonString == null) return [];
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList
      .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

String _encodeProducts(List<ProductModel> products) {
  final jsonList = products.map((prod) => prod.toJson()).toList();
  return json.encode(jsonList);
}

class ProductMgtLocalDataSourceImpl implements ProductMgtLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProductMgtLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> pdts) async {
    try {
      final jsonString = _encodeProducts(pdts);
      await sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSingleProduct(ProductModel pdt) async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
      List<ProductModel> products = _decodeProducts(jsonString);
      // Check if product exists, update or add
      final index = products.indexWhere((element) => element.id == pdt.id);
      if (index != -1) {
        products[index] = pdt; // Update existing
      } else {
        products.add(pdt); // Add new
      }

      // Save updated list
      final updatedJsonString = _encodeProducts(products);
      await sharedPreferences.setString(CACHED_PRODUCTS, updatedJsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCachedProduct(ProductModel pdt) async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
      if (jsonString != null) {
        // final List<dynamic> jsonList = json.decode(jsonString);
        List<ProductModel> products = _decodeProducts(jsonString);
        // Remove the product with the matching id
        products.removeWhere((element) => element.id == pdt.id);
        // Save the updated list
        final updatedJsonString = _encodeProducts(products);
        await sharedPreferences.setString(CACHED_PRODUCTS, updatedJsonString);
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<ProductModel> products =  _decodeProducts(jsonString);
      return Future.value(products);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getCachedSingleProduct(int id) {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final products = _decodeProducts(jsonString);
      try {
        final product = products.firstWhere((pdt) => pdt.id == id);
        return Future.value(product);
      } catch (e) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}
