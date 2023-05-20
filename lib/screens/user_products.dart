import 'package:flutter/material.dart';
import 'package:shop_app/widgets/decoration_widget.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_manager.dart';
import './edit_products.dart';

class UserProducts extends StatefulWidget {
  static const routeName = "/user-products";

  @override
  State<UserProducts> createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  Future? _productsFuture;
  Future<void> _editProductsFuture() async {
    return await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndAddProducts(true);
  }

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<ProductsProvider>(ctx, listen: false)
        .fetchAndAddProducts(true);
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = _editProductsFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
          const Color(0xFF495579),
          const Color(0xFF3C2A21),
        ))),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
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
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Stack(children: [
                      Container(
                          decoration: BoxDecoration(
                              gradient:
                                  CustomLinearGradient.baseBackgroundDecoration(
                        const Color(0xFF495579),
                        const Color(0xFF3C2A21),
                      ))),
                      Consumer<ProductsProvider>(
                          builder: (ctx, product, _) => ListView.builder(
                                itemBuilder: (ctx, i) => UserManageItems(
                                    product.items[i].id,
                                    product.items[i].title,
                                    product.items[i].imageUrl),
                                itemCount: product.items.length,
                              )),
                    ]),
                  ),
      ),
    );
  }
}
