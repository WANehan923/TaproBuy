
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taprobuy/Models/ThemeModeNotifier.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/items/ItemDrawer.dart';
import 'package:taprobuy/screens/Cart.dart';
import 'package:taprobuy/screens/Products.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // The 'addToCart()' method is called upon when the 'Add To Cart' button is pressed.
  void addToCart(Map<String, dynamic> product) {
    // Check if the product is already in the cart.
    bool isInCart =
        CartItems.cart.any((item) => item['Name'] == product['Name']);
    // If the product is not in the cart, we add it with an initial quantity of '1'.
    if (!isInCart) {
      product['Quantity'] = 1;
      CartItems.cart.add(product);

      // A snack bar is displayed to show that the product already exists in the cart.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item added to cart")),
      );
      // A snack bar is displayed to show that the item has already been added to the cart.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item already in cart")),
      );
    }
  }

  void Logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
        builder: (context, themeNotifier, child) {
      return Theme(
        data: ThemeData(
          primaryColor: k_primary,
          brightness: themeNotifier.themeMode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: Logout,
                  icon: Icon(Icons.logout, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.local_mall),
                color: k_background,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
              )
            ],
            backgroundColor: k_primary,
          ),
          drawer: const ItemDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ProductListPage(onAddToCart: addToCart),
              ),
            ],
          ),
        ),
      );
    });
  }
}




