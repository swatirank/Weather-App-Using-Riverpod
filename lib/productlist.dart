import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Product {
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "def", price: 25),
  Product(name: "abc", price: 10),
  Product(name: "ghi", price: 36),
  Product(name: "mno", price: 30),
  Product(name: "jkl", price: 20),
];

enum ProductSortType { name, price }

final productSortTypeProvider = StateProvider<ProductSortType>(
  (ref) => ProductSortType.name,
);

final futureProductProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(Duration(seconds: 1));
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      _products.sort((a, b) => a.name.compareTo(b.name));
      break;
    case ProductSortType.price:
      _products.sort((a, b) => a.price.compareTo(b.price));
      break;
  }
  return _products;
});

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple List', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: DropdownButton<ProductSortType>(
                    menuWidth: 150,
                    alignment: Alignment.centerRight,
                    underline: Container(),
                    isDense: true,
                    iconSize: 40,
                    icon: Icon(Icons.arrow_drop_down, size: 40),
                    value: ref.watch(productSortTypeProvider),
                    items: const [
                      DropdownMenuItem(
                        value: ProductSortType.price,
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort,
                              color: Color.fromARGB(255, 70, 69, 69),
                            ),
                            SizedBox(width: 10),
                            Text('Price'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: ProductSortType.name,
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort_by_alpha,
                              color: Color.fromARGB(255, 70, 69, 69),
                            ),
                            SizedBox(width: 10),
                            Text('Name'),
                          ],
                        ),
                      ),
                    ],
                    onChanged:
                        (value) =>
                            ref.watch(productSortTypeProvider.notifier).state =
                                value!,
                  ),
                ),
              ),
            ),
            Expanded(
              child: productsProvider.when(
                data:
                    (products) => ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: Card(
                            color: Colors.blueAccent,
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                products[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                "${products[index].price}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                error:
                    (err, stack) => Text(
                      "Error: $err",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                loading:
                    () => Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
