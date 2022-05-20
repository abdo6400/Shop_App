import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routename = '/UserProductsScreen';

  Future<void> _refershProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .FatchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routename),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refershProduct(context),
        builder: (ctx, snp) => snp.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refershProduct(context),
                child: Consumer<Products>(
                  builder: (ctx, product, _) => Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: product.items.length,
                      itemBuilder: (ctx, index) => Column(
                        children: [
                          UserProductItem(product.items[index].id,product.items[index].title,product.items[index].imageUrl),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
