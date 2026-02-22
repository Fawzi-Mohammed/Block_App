import 'dart:convert';

import 'package:block_app/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepo {
  Future<List<ProductModel>> getData() async {
    final url = Uri.https('fakestoreapi.com', 'products');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded
          .map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Fail To Get Data');
    }
  }
}
