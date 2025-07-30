import 'package:flutter/material.dart';

import 'home_page.dart';
import 'product.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});
  @override
  Widget build(BuildContext context) {
    Product pd = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: Utils().padding(),
              child: Stack(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                      )
                    ),
                    child: Image.asset(
                      pd.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: Utils().padding(ver: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(pd.name), Text('\$${pd.price}')],
              ),
            ),

            Padding(
              padding: Utils().padding(ver: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${pd.category} Shoes'),
                  const Row(children: [Icon(Icons.star), Text('(4.0)')]),
                ],
              ),
            ),

            Padding(
              padding: Utils().padding(ver: 16),
              child: const Text('Size'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ShoeSizeList(),
            ),
            Padding(
              padding: Utils().padding(),
              child: Text(pd.description),
            ),
            Padding(
              padding: Utils().padding(ver: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Delete')),
                  FilledButton(onPressed: () {}, child: const Text('Update')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoeSizeList extends StatelessWidget {
  const ShoeSizeList({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Text('${index + 39}'),
          );
        },
      ),
    );
  }
}
