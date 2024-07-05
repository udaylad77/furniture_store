import 'dart:convert';
import 'package:furniture_store/model/product_model.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Product> products =
        data.map((item) => Product.fromJson(item)).toList();
    return products;
  } else {
    throw Exception('Failed to load products');
  }
}
