import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  getData(String authTok, String uId, List<OrderItem> orders) {
    authToken = authTok;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> FatchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-d4473-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final List<OrderItem> loadOrders = [];
      extractedData.forEach((OrderId, OrderData) {
        OrderItem(
          id: OrderId,
          amount: OrderData['amount'],
          dateTime: DateTime.parse(OrderData['dateTime']),
          products: (OrderData['products'] as List<dynamic>).map((item) =>
                CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
          ).toList(),
        );
      });
      _orders = loadOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> AddOrder(List<CartItem> cartproducts, double total) async {
    final url = Uri.parse(
        'https://shop-d4473-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final timestamp = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartproducts.map((cp) =>
            {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            }).toList(),
          }));
      _orders.insert(0, OrderItem(id: json.decode(res.body)['name'],
          amount: total,
          products: cartproducts,
          dateTime: timestamp));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
