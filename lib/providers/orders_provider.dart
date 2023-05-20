import 'package:flutter/material.dart';
import 'cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dbUrl/db_url.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;
  OrderItem(
      {required this.id,
      required this.products,
      required this.date,
      required this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse("$dbUrl/orders/$userId.json?auth=$authToken");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']))
                .toList(),
            date: DateTime.parse(orderData['date']),
            amount: orderData['amount']));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    final url = Uri.parse("$dbUrl/orders/$userId.json?auth=$authToken");
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "date": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cartProduct) => {
                    "id": cartProduct.id,
                    "price": cartProduct.price,
                    "title": cartProduct.title,
                    "quantity": cartProduct.quantity
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProducts,
            date: timeStamp,
            amount: total));
    notifyListeners();
  }
}
