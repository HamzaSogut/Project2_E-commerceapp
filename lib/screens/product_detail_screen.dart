import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/decoration_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-page';

  TextStyle styleBuilder(BuildContext ctx, double fontSize) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: const [
          Shadow(offset: Offset(1, 1), blurRadius: 1, color: Colors.black)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
              const Color(0xFF495579),
              const Color(0xFF3C2A21),
            )),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: Theme.of(context).appBarTheme.elevation,
          centerTitle: AppBarTheme.of(context).centerTitle,
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: CustomLinearGradient.baseBackgroundDecoration(
            const Color(0xFF495579),
            const Color(0xFF3C2A21),
          )),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    width: double.infinity,
                    height: 250,
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Center(
                        child: Text(loadedProduct.title,
                            style: styleBuilder(context, 30)),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("about the product :",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text(loadedProduct.description,
                                style: styleBuilder(context, 20)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Price :",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              "Price: \$${loadedProduct.price}",
                              style: styleBuilder(context, 20),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                          height: 100,
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Consumer<Cart>(
                            builder: (_, cart, child) => ElevatedButton.icon(
                              onPressed: () => cart.addItem(loadedProduct.id,
                                  loadedProduct.title, loadedProduct.price),
                              label: const Icon(Icons.add_shopping_cart_rounded,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 1,
                                        offset: Offset(1, 1),
                                        color: Colors.black)
                                  ]),
                              icon: const Text(
                                "Add To Cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    shadows: [
                                      Shadow(
                                          blurRadius: 1,
                                          offset: Offset(1, 1),
                                          color: Colors.black)
                                    ]),
                              ),
                            ),
                          ))
                    ],
                  ))
                ]),
              )
            ],
          ),
        ));
  }
}
