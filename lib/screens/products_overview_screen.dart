import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../widgets/decoration_widget.dart';
import '../widgets/drawer.dart';
import 'cart_screen.dart';
import '../widgets/grid_builder.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

enum FilterOpitions { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  var _isLoading = false;

  Future<void> checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result.name != "none") {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndAddProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      _showDialog();
    }
  }

  void _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content:
                  const Text("Please connect to the internet and try again"),
              title: const Text("error occurred"),
              actions: [
                TextButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: const Text("ok"))
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: Theme.of(context).appBarTheme.elevation,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: CustomLinearGradient.baseBackgroundDecoration(
              const Color(0xFF495579),
              const Color(0xFF3C2A21),
            ),
          ),
        ),
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOpitions value) {
              setState(() {
                if (value == FilterOpitions.favorite) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOpitions.favorite,
                child: Text("Only Favorite"),
              ),
              const PopupMenuItem(
                value: FilterOpitions.all,
                child: Text("Show All"),
              )
            ],
            icon: const Icon(Icons.more_vert_outlined),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badgee(
              value: cart.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: _isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: CustomLinearGradient.baseBackgroundDecoration(
                const Color(0xFF495579),
                const Color(0xFF3C2A21),
              )),
              child: const Center(child: CircularProgressIndicator()),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
                  const Color(0xFF495579),
                  const Color(0xFF3C2A21),
                ),
              ),
              child: ProductsGrid(_showOnlyFavorites)),
      drawer: const AppDrawer(),
    );
  }
}
