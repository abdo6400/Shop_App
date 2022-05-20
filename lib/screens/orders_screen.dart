import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import '../providers/orders.dart' show Orders hide OrderItem;

class OrdersScreen extends StatelessWidget {
  static const routename = '/OrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrdersScreen'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).FatchAndSetOrders(),
        builder: (ctx, snp) {
          if (snp.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snp.error != null) {
              return Center(child: Text('An error occured!'),);
            }
            else {
              return Consumer<Orders>(
                builder:(ctx,OrderData,child)=>ListView.builder(
                     itemCount: OrderData.orders.length,
                    itemBuilder: (ctx,index) => OrderItem(OrderData.orders[index]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
