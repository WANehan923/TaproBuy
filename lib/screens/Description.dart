import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:taprobuy/Models/ThemeModeNotifier.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/items/ItemDrawer.dart';

class ProductDescription extends StatelessWidget {
  final Map<String, dynamic>? product;
  final void Function(Map<String, dynamic>)? onProductTap;
  ProductDescription({Key? key, this.product, this.onProductTap})
      : super(key: key);

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
              backgroundColor: k_primary,
            ),
            drawer: const ItemDrawer(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.network(product!['URL'],
                        width: 400, height: 400, fit: BoxFit.cover),
                    SizedBox(height: 20),
                    Text(
                      product != null
                          ? product!['Name'] ?? 'Brain Cell'
                          : 'Unknown',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      product!['Price'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      product!['Description'],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}