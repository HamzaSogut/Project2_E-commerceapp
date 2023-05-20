import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart';
import 'decoration_widget.dart';

class OrderItemBuilder extends StatefulWidget {
  final OrderItem order;
  const OrderItemBuilder(this.order);

  @override
  State<OrderItemBuilder> createState() => _OrderItemBuilderState();
}

class _OrderItemBuilderState extends State<OrderItemBuilder> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 100, 200) : 85,
      decoration: BoxDecoration(
          gradient: CustomLinearGradient.baseBackgroundDecoration(
              const Color(0xFF16213E), const Color(0xFF100F0F)),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(
            "Total Price is :\$${widget.order.amount.toStringAsFixed(2)}",
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            icon: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          height: _expanded
              ? min(widget.order.products.length * 20.0 + 20, 100)
              : 0,
          child: ListView.builder(
            itemBuilder: (ctx, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.order.products[index].title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.order.products[index].quantity}x \$${widget.order.products[index].price}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            ),
            itemCount: widget.order.products.length,
          ),
        ),
      ]),
    );
  }
}
