import 'package:flutter/material.dart';
import '../screens/edit_products.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import './decoration_widget.dart';

class UserManageItems extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  const UserManageItems(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: CustomLinearGradient.baseBackgroundDecoration(
                const Color(0xFF16213E), const Color(0xFF100F0F))),
        child: ListTile(
          leading:
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          trailing: Container(
            width: 100,
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EditProductsScreen.routeName,
                        arguments: id);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.amber,
                  )),
              IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      scaffold.showSnackBar(const SnackBar(
                          content: Text(
                        "deleting failed",
                        textAlign: TextAlign.center,
                      )));
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
