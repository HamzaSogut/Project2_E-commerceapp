import 'package:flutter/material.dart';
import '../screens/user_products.dart';
import '../screens/orders_screen.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeData = MediaQuery.of(context);
    return SafeArea(
      child: Drawer(
        width: sizeData.size.width * 0.6,
        child: ListView(children: [
          /*  Container(
            height: 100,
            child: DrawerHeader(
                child: Center(
                    child: Text(
              "Hello Friend!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ))),
          ),*/
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
            leading: const Icon(Icons.home),
            title: const Text("Home Page"),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, UserProducts.routeName);
            },
            leading: const Icon(Icons.edit),
            title: const Text("Edit Products"),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Log out"),
          )
        ]),
      ),
    );
  }
}
