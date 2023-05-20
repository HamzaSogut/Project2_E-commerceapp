import 'package:flutter/material.dart';
import './providers/auth_provider.dart';

import '../screens/product_detail_screen.dart';
import './screens/splash_screen.dart';
import 'screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import 'screens/cart_screen.dart';
import './providers/orders_provider.dart';
import './screens/orders_screen.dart';
import './screens/user_products.dart';
import './screens/edit_products.dart';
import 'screens/signIn_screen.dart';
import './screens/signUp_screen.dart';
import './helpers/custom_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
              update: (ctx, auth, previousProductsProvider) => ProductsProvider(
                  auth.token ?? '',
                  auth.userId ?? '',
                  previousProductsProvider?.items ?? []),
              create: (ctx) => ProductsProvider('', '', [])),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (ctx, auth, previousOrdersProvider) => Orders(
                  auth.token ?? '',
                  auth.userId ?? '',
                  previousOrdersProvider?.orders ?? []),
              create: (ctx) => Orders('', '', []))
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrdersScreen.routeName: (context) => OrdersScreen(),
                UserProducts.routeName: ((context) => UserProducts()),
                EditProductsScreen.routeName: (context) => EditProductsScreen(),
                SignInScreen.routeName: (context) => SignInScreen(),
                SignUpScreen.routeName: (context) => SignUpScreen()
              },
              theme: ThemeData(
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder()
                  }),
                  appBarTheme: const AppBarTheme(
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0),
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                          .copyWith(
                              secondary: Colors.deepOrange,
                              primary: Colors.blueGrey),
                  fontFamily: 'Lato'),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authSnapshot) =>
                          authSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : SignInScreen(),
                    )),
        ));
  }
}
