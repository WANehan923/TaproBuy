import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taprobuy/Models/ThemeModeNotifier.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/items/ItemDrawer.dart';
import 'package:taprobuy/screens/Cart.dart';

class BuyNow extends StatefulWidget {
  const BuyNow({super.key});

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  String? shipValue;
  String? payValue;
  bool showCardDetails = false;
  bool canPlaceOrder = false;
  bool orderPlaced = false;

  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  // Calculate the total price of the items in the cart.
  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in CartItems.cart) {
      double price = double.parse(
          (item['Price'] ?? '0').replaceAll(RegExp(r'[^0-9.]'), ''));
      int quantity = item['Quantity'] ?? 0;
      totalPrice += price * quantity;
    }
    return totalPrice;
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
            backgroundColor: const Color.fromARGB(255, 63, 70, 143),
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
                icon: const Icon(Icons.local_mall),
                color: k_background,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
              ),
            ],
          ),
          drawer: const ItemDrawer(),
          body: Container(
            margin: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Shipping Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    controller: shippingAddressController,
                    onChanged: (value) {
                      setState(() {
                        checkOrderButton();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your shipping address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Shipping Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: shipValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          shipValue = newValue;
                          checkOrderButton();
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(),
                      items: <String>[
                        'Select a shipping method',
                        'Ground shipping',
                        'Air freight',
                        'Ocean freight',
                        'Pick up at store',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: payValue,
                      onChanged: (String? newPaymentValue) {
                        setState(() {
                          payValue = newPaymentValue;
                          if (newPaymentValue == 'Credit card' ||
                              newPaymentValue == 'Debit card') {
                            showCardDetails = true;
                          } else {
                            showCardDetails = false;
                          }
                          checkOrderButton();
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(),
                      items: <String>[
                        'Select a payment method',
                        'Cash',
                        'Credit card',
                        'Debit card',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  if (showCardDetails)
                    Column(
                      children: [
                        TextField(
                          controller: cardNumberController,
                          onChanged: (value) {
                            setState(() {
                              checkOrderButton();
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Card Number',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextField(
                                controller: expiryDateController,
                                onChanged: (value) {
                                  setState(() {
                                    checkOrderButton();
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Expiry Date',
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: TextField(
                                controller: cvvController,
                                onChanged: (value) {
                                  setState(() {
                                    checkOrderButton();
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'EST.TOTAL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'RS.${calculateTotalPrice().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(400, 50)),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => canPlaceOrder &&
                                  shippingAddressController.text.isNotEmpty
                              ? const Color.fromARGB(255, 63, 70, 143)
                              : Colors.grey),
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => canPlaceOrder &&
                                  shippingAddressController.text.isNotEmpty
                              ? Colors.white
                              : Colors.black),
                    ),
                    onPressed: orderPlaced || !canPlaceOrder
                        ? null
                        : () {
                            setState(() {
                              orderPlaced = true;
                              canPlaceOrder = false;
                            });
                            showTransactionProcessingDialog(context);
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.of(context).pop();
                              showOrderConfirmationDetails(context);
                            });
                          },
                    child: const Text("Place Order"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void showTransactionProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Processing transaction"),
          content: LinearProgressIndicator(),
        );
      },
    );
  }

  void showOrderConfirmationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Transaction successful"),
          content: const Text("Your order has been placed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void checkOrderButton() {
    bool isProductsPresentInCart = CartItems.cart.isNotEmpty;
    double totalPrice = calculateTotalPrice();
    bool isCardPayment = payValue == 'Credit card' || payValue == 'Debit card';

    if (isProductsPresentInCart &&
        totalPrice > 0 &&
        shipValue != null &&
        shipValue != 'Select a shipping method' &&
        payValue != null &&
        payValue != 'Select a payment method' &&
        shippingAddressController.text.isNotEmpty &&
        ((payValue != 'Credit card' && payValue != 'Debit card') ||
            (isCardPayment &&
                (cardNumberController.text.isNotEmpty &&
                    expiryDateController.text.isNotEmpty &&
                    cvvController.text.isNotEmpty &&
                    cvvController.text.length == 3)))) {
      setState(() {
        canPlaceOrder = true;
      });
    } else {
      setState(() {
        canPlaceOrder = false;
      });
    }
  }
}
