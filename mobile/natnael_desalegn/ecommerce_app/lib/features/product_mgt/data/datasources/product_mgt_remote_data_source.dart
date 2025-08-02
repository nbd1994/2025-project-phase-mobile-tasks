import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductMgtRemoteDataSource {
  Future<ProductModel> deleteProduct(int id);
  Future<ProductModel> getProduct(int id);
  Future<ProductModel> insertProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<List<ProductModel>> getAllProducts();
}

// ignore: constant_identifier_names
const BASE_URL =
    'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/';

class ProductMgtRemoteDataSourceImpl implements ProductMgtRemoteDataSource {
  final http.Client client;

  ProductMgtRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductModel> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse('$BASE_URL$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse(BASE_URL),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    final response = await client.get(
      Uri.parse('$BASE_URL$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> insertProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse(BASE_URL),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$BASE_URL${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
