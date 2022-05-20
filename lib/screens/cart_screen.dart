import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/cart_item.dart';
import '../providers/orders.dart';
import '../providers/cart.dart' show Cart hide CartItem;

class CartScreen extends StatelessWidget {
  static const routename = '/Cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                        label:
                            Text('\$${cart.totalAmount.toStringAsFixed(2)}')),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, index) => CartItem(
                          cart.items.values.toList()[index].id,
                          cart.items.keys.toList()[index],
                          cart.items.values.toList()[index].price,
                          cart.items.values.toList()[index].quantity,
                          cart.items.values.toList()[index].title,
                        ))),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart? cart;

  OrderButton({@required this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart!.totalAmount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Orders>(context, listen: false).AddOrder(
                widget.cart!.items.values.toList(),
                widget.cart!.totalAmount,
              );
              setState(() {
                _isloading = false;
              });
              widget.cart!.clear();
            },
      child: _isloading ? CircularProgressIndicator() : Text('ORDER NOW'),
    );
  }
}
