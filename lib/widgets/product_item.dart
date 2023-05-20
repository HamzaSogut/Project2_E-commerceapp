import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black87,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ProductDetailScreen.routeName,
                          arguments: product.id);
                    },
                    child: FadeInImage(
                      placeholder:
                          const AssetImage('assets/images/loading.jpg'),
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<Product>(
                    builder: ((ctx, product, child) => IconButton(
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            product.toggleFavorite(
                                authData.token, authData.userId);
                          },
                        )),
                  ),
                  Expanded(
                    child: Text(
                      product.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                offset: const Offset(1, 1),
                                color: Theme.of(context).colorScheme.secondary,
                                blurRadius: 1)
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: (() {
                      cart.addItem(product.id, product.title, product.price);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("Added to the cart!"),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: "undo",
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      ));
                    }),
                  ),
                ],
              )
            ],
          )),
      Positioned(
          bottom: 60,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black54,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Price: ${product.price}",
                style: const TextStyle(color: Colors.white, shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(1, 1), blurRadius: 1)
                ]),
              ),
            ),
          ))
    ]);
  }
}
