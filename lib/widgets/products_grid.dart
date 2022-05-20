import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'product_item.dart';

class ProductsGride extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGride(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavorites ? productsData.FavoriteItems : productsData.items;
    return products.isEmpty
        ? Center(
            child: Text('There is no products!'),
          )
        : Container(
          padding: EdgeInsets.all(8.0),
          child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(),
              ),
            ),
        );
  }
}
