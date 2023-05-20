import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import './decoration_widget.dart';

class CartItemData extends StatelessWidget {
  final CartItem cartItem;
  final String productId;
  const CartItemData(this.productId, this.cartItem);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("remove the item"),
                  content: const Text(
                      "are you sure you want to remove this item from the cart ?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, true);
                        },
                        child: const Text("yes")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, false);
                        },
                        child: const Text("no"))
                  ],
                ));
      },
      onDismissed: ((direction) {
        cart.removeItem(productId);
      }),
      key: ValueKey(cartItem.id),
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black38,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            gradient: CustomLinearGradient.baseBackgroundDecoration(
                const Color(0xFF16213E), const Color(0xFF100F0F)),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: FittedBox(
                        child: Text(
                      '\$${cartItem.price}',
                      style: const TextStyle(color: Colors.white, shadows: [
                        Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 0.5)
                      ]),
                    )))),
            title: Text(
              cartItem.title,
              style: TextStyle(color: Colors.white, shadows: [
                Shadow(
                    color: Theme.of(context).colorScheme.secondary,
                    offset: const Offset(1, 1),
                    blurRadius: 1)
              ]),
            ),
            subtitle: Text(
              'Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, shadows: [
                Shadow(
                    color: Theme.of(context).colorScheme.secondary,
                    offset: const Offset(1, 1),
                    blurRadius: 1)
              ]),
            ),
            trailing: /*Text('$quantity x'),*/ Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: (cartItem.quantity > 1)
                        ? () => {
                              Provider.of<Cart>(context, listen: false)
                                  .addOrRemoveQuantity(productId, false)
                            }
                        : () => {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: const Text("remove item"),
                                        content: const Text(
                                            "Are you sure you want to remove this item from the cart?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Provider.of<Cart>(context,
                                                        listen: false)
                                                    .removeItem(productId);
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text("remove")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text("keep"))
                                        ],
                                      )),
                            },
                    icon: Icon(Icons.remove,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Text(
                    '${cartItem.quantity}x',
                    style: TextStyle(color: Colors.white, shadows: [
                      Shadow(
                          color: Theme.of(context).colorScheme.secondary,
                          offset: const Offset(1, 1),
                          blurRadius: 1)
                    ]),
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .addOrRemoveQuantity(productId, true);
                    },
                    icon: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
