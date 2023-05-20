import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders_provider.dart';
import '../widgets/decoration_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";
  Widget buildContainer(Color x, Color y) {
    return Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [x, y])));
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:
            buildContainer(const Color(0xFF495579), const Color(0xFF3C2A21)),
        title: const Text("Cart"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: CustomLinearGradient.baseBackgroundDecoration(
          const Color(0xFF495579),
          const Color(0xFF3C2A21),
        )),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: CustomLinearGradient.baseBackgroundDecoration(
                  const Color(0xFF16213E),
                  const Color(0xFF100F0F),
                )),
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Total",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        )),
                    const Spacer(),
                    Chip(
                      label: Text(
                        "\$${cart.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    OrderButton(cart: cart)
                  ]),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, index) => CartItemData(
                      cart.items.keys.toList()[index],
                      CartItem(
                          id: cart.items.values.toList()[index].id,
                          price: cart.items.values.toList()[index].price,
                          title: cart.items.values.toList()[index].title,
                          quantity:
                              cart.items.values.toList()[index].quantity))))
        ]),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalPrice,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              "Order Now",
              style: const TextStyle(color: Colors.white),
            ),
    );
  }
}
