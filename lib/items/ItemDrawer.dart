import 'package:flutter/material.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/screens/Account.dart';
import 'package:taprobuy/screens/BuyNow.dart';
import 'package:taprobuy/screens/Cart.dart';
import 'package:taprobuy/screens/Description.dart';
import 'package:taprobuy/screens/Home.dart';

class ItemDrawer extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ItemDrawer({super.key, this.product});

  @override
  State<ItemDrawer> createState() => _ItemDrawerState();
}

class _ItemDrawerState extends State<ItemDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: k_primary,
        ),
        child: const Text(
          'TaproBuy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
      ),
      ListTile(
        leading: const Icon(Icons.shopping_cart),
        title: const Text('Cart'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        },
      ),
      ListTile(
        leading: const Icon(Icons.shopping_cart_checkout),
        title: const Text('Checkout'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BuyNow()));
        },
      ),
      ListTile(
        leading: const Icon(Icons.account_box_rounded),
        title: const Text('Account'),
        onTap: () {
          Navigator.pop(context);
          // Implement the 'Navigation.push' once the 'Account' page has been constructed.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Account()),
          );
        },
      ),
    ]));
  }
}
