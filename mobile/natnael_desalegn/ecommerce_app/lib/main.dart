import 'package:flutter/material.dart';

import 'add_product.dart';
import 'home_page.dart';
import 'product_details.dart';
import 'search_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add-product': (context) => const AddProduct(),
        '/product-details': (context) => const ProductDetails(),
        '/search': (context) => const SearchProduct(),
      },
      title: 'Flutter Demo',
    );
  }
}
