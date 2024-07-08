import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taprobuy/Models/ThemeModeNotifier.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/items/ItemDrawer.dart';
import 'package:taprobuy/screens/BuyNow.dart';
import 'package:taprobuy/screens/Home.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
          // Returns a 'Scaffold' widget that consists of the 'AppBar' along with a menu icon, that reveals a drawer when clicked on.
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
            backgroundColor: k_primary,
          ),
          // We call the 'ItemDrawer' class from the 'ItemDrawer.dart' page.
          drawer: const ItemDrawer(),
          // We use a column to display the text 'Cart' and use an 'Expanded' widget to prevent any overflow error.
          // It checks whether the cart is empty or not by iterating through the items in the cart.
          // If the cart is empty, a text called 'Your cart is empty' is displayed along with an elevated button called 'Continue Shopping' in-order to direct the user to the home page to continue shopping.
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Cart",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CartItems.cart.isEmpty
                    ? _buildEmptyCartView(context)
                    : ListView.builder(
                        itemCount: CartItems.cart.length,
                        itemBuilder: (context, index) {
                          final item = CartItems.cart[index];

                          // Extract the numerical section of the 'Price' string and parse it to double.
                          final double Price = double.parse(
                              (item['Price'] ?? '0')
                                  .replaceAll(RegExp(r'[^0-9.]'), ''));

                          // Parse the 'Quantity' to double.
                          final int Quantity = item['Quantity'] ?? 0;

                          // Calculate the total price of the product.
                          double totalPrice = Price * Quantity;

                          // The details of the added products are displayed within a card.
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              leading: Image.network(item['URL'] ?? ''),
                              title: Text(item['Name'] ?? 'Brain Cell'),
                              // Display the total price of the product.
                              subtitle:
                                  Text('\RS ${totalPrice.toStringAsFixed(2)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (item['Quantity'] > 1) {
                                        setState(() {
                                          item['Quantity']--;
                                        });
                                      }
                                    },
                                  ),
                                  Text(item['Quantity']?.toString() ?? ''),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        item['Quantity'] =
                                            (item['Quantity'] ?? 0) + 1;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        CartItems.cart.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // The 'Proceed To Checkout' button will be displayed if there is atleast one product in the cart.
              if (CartItems.cart.isNotEmpty)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 63, 70, 143)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BuyNow()),
                    );
                  },
                  child: const Text(
                    "Proceed To Checkout",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // The '_buildEmptyCartView' is called if the cart is empty.
  Widget _buildEmptyCartView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          },
          child: Text('Continue shopping'),
        ),
      ],
    );
  }
}

// The 'CartItems' class consists of a list of products that are added to the cart dynamically.
class CartItems {
  static List<Map<String, dynamic>> cart = [];
}
