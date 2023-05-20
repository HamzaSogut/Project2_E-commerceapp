import 'package:flutter/material.dart';
import '../widgets/decoration_widget.dart';
import '../widgets/order_item.dart';
import '../providers/orders_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() async {
    return await Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: CustomLinearGradient.baseBackgroundDecoration(
                const Color(0xFF495579),
                const Color(0xFF3C2A21),
              ),
            ),
          ),
          title: const Text("Order Now"),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: Container(
            decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
              const Color(0xFF495579),
              const Color(0xFF3C2A21),
            )),
            child: FutureBuilder(
              future: _ordersFuture,
              builder: (ctx, dataSnapShot) {
                if (dataSnapShot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (dataSnapShot.error != null) {
                    return const Center(
                      child: Text("error"),
                    );
                  } else {
                    return Consumer<Orders>(builder: (ctx, orderData, child) {
                      return orderData.orders.isEmpty
                          ? const Center(
                              child: Text(
                                "please go back and place an order",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black,
                                          blurRadius: 1,
                                          offset: Offset(1, 1))
                                    ]),
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, i) =>
                                  OrderItemBuilder(orderData.orders[i]),
                              itemCount: orderData.orders.length);
                    });
                  }
                }
              },
            )));
  }
}
