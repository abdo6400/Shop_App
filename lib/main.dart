//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/Startpage.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_overview_screen.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousProducts) => previousProducts..getData(
                authValue.token, authValue.userId,previousProducts.orders),
        ),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProducts) =>previousProducts..getData(
              authValue.token, authValue.userId,previousProducts.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx,auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.black,
              accentColor: Colors.green,
              fontFamily: 'Lato'
          ),
          home: auth.isAuth? StartPage() : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snp) =>
                      snp.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            CartScreen.routename: (_) => CartScreen(),
            EditProductScreen.routename: (_) => EditProductScreen(),
            OrdersScreen.routename: (_) => OrdersScreen(),
            ProductDetailScreen.routename: (_) => ProductDetailScreen(),
            UserProductsScreen.routename: (_) => UserProductsScreen(),
          },
        ),
      ),
    );
  }
}
