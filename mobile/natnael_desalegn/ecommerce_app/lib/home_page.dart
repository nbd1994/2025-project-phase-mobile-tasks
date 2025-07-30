import 'package:flutter/material.dart';
import 'product.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: ()=> Navigator.pushNamed(context, '/add-product'),
        icon: const Icon(Icons.add_circle),
        iconSize: 60,
        color: Colors.green,
      ),
      body: const SingleChildScrollView(
        child:Column(
          children: [
            MyAppBar(),
            MyAvailableProductsTitle(),
            ProductsList(itemCount: 4),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: Utils().padding(),
      leading: CircleAvatar(child: Image.asset('assets/images/avatar.jpg')),
      title: const Text('july 3, 2023'),
      subtitle: const Text('Hello, Yohannes'),
      trailing: const Icon(Icons.notifications_active),
    );
  }
}

class MyAvailableProductsTitle extends StatelessWidget {
  const MyAvailableProductsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils().padding(ver: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Available Products'),
          IconButton(
            onPressed: ()=>Navigator.pushNamed(context, '/search'),
            icon: const Icon(Icons.search),
          )
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.pdt});
  final Product pdt;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => Navigator.pushNamed(context, '/product-details', arguments: pdt),
      child: Card(
        clipBehavior: Clip.antiAlias,
        // elevation: ,
        color: const Color.fromARGB(234, 255, 255, 255),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              pdt.image,
              width: double.infinity,
              height:110.0 ,
              fit: BoxFit.cover,
            ),
            // Container(height: 120.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(pdt.name),
                Text('\$${pdt.price}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${pdt.category} Shoes'),
                const Row(
                  children: [
                    Icon(Icons.star),
                    Text('(4.0)')
                  ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Utils {
  EdgeInsets padding({hor = 25.0, ver = 0.0}) {
    return EdgeInsets.fromLTRB(hor, ver, hor, 0.0);
  }

  String dummyText(){
    return 'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.';
  }
}

class ProductsList extends StatelessWidget {
  const ProductsList({super.key, required this.itemCount});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 5 / 2.7,
      crossAxisCount: 1,
      mainAxisSpacing: 20,
      padding: Utils().padding(),
      shrinkWrap: true,
      children: List.generate(
        products.length,
        (int index) => ProductCard(pdt: products[index])
      ),
    );
  }
}
