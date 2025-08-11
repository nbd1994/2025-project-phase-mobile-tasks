import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductMgtRemoteDataSource {
  Future<ProductModel> deleteProduct(String id);
  Future<ProductModel> getProduct(String id);
  Future<ProductModel> insertProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<List<ProductModel>> getAllProducts();
}

// ignore: constant_identifier_names


class ProductMgtRemoteDataSourceImpl implements ProductMgtRemoteDataSource {
  final http.Client client;

  ProductMgtRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductModel> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('${ApiUrls.baseUrlProducts}$id'),
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
      Uri.parse(ApiUrls.baseUrlProducts),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = decoded['data'];
      return jsonList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(
      Uri.parse('${ApiUrls.baseUrlProducts}$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return ProductModel.fromJson(decoded['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> insertProduct(ProductModel product) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiUrls.baseUrlProducts));

    request.fields['name'] = product.name;
    request.fields['price'] = product.price.toString();
    request.fields['description'] = product.description;

    if(product.imageUrl.isNotEmpty){
      request.files.add(await http.MultipartFile.fromPath('image', product.imageUrl, contentType: MediaType('image', 'jpeg')));
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return ProductModel.fromJson(decoded['data']);
    } else {
      print('API Error: ${response.body}');
      throw ServerException();
    }
  
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('${ApiUrls.baseUrlProducts}${product.id}'),
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
