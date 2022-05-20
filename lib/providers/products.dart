import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
 List<Product> _items = [
   Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  String? authToken;
  String? userId;

  getData(String authTok, String uId, List<Product> Products) {
    authToken = authTok;
    userId = uId;
    _items = Products;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get FavoriteItems {
    return _items.where((productitem) => productitem.isFavorite).toList();
  }

  Product findbyId(String id) {
    return _items.firstWhere((productitem) => productitem.id == id);
  }

  Future<void> FatchAndSetProducts([bool? filter]) async {
    final filteredString =
        filter! ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shop-d4473-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString');
    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) return;

      url = Uri.parse(
          'https://shop-d4473-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favres = await http.get(url);
      final extractedFavData = json.decode(favres.body);
      final List<Product> loadProducts = [];
      extractedData.forEach((ProdId, ProdData) {
        Product(
          id: ProdId,
          title: ProdData['title'],
          description: ProdData['description'],
          price: ProdData['price'],
          imageUrl: ProdData['imageUrl'],
          isFavorite:
              extractedFavData == null ? false : ProdData[ProdId] ?? false,
        );
      });
      _items = loadProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> AddProduct(Product product) async {
    final url = Uri.parse('https://shop-d4473-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final res = await http.post(url,
          body: json.encode({
            'creatorId': userId,
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price
          }));
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> UpdateProduct(String id, Product newproduct) async {
    final productindex = _items.indexWhere((prod) => prod.id == id);
    if (productindex >= 0) {
      final url = Uri.parse(
          'https://shop-d4473-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'imageUrl': newproduct.imageUrl,
            'price': newproduct.price
          }));
      _items[productindex] = newproduct;
      notifyListeners();
    } else {
      print('!!!');
    }
  }

  Future<void> DeleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-d4473-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingproductindex = _items.indexWhere((prod) => prod.id == id);
    Product? existingproduct = _items[existingproductindex];
    _items.removeAt(existingproductindex);
    notifyListeners();
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(existingproductindex, existingproduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingproduct = null;
  }
}
