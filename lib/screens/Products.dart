import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taprobuy/screens/Description.dart';

class ProductListPage extends StatefulWidget {
  // Create the 'onAddToCart' function to add products to the cart.
  final Function(Map<String, dynamic>) onAddToCart;
  const ProductListPage({super.key, required this.onAddToCart});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final products = snapshot.data!.docs;
//==============================GridView??====================================
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index].data();
            // Creates a product card widget for each product instance and uses the 'id' property of the document in the fire-store collection.
            // The details of the product is passed onto the 'ProductCard' widget as a 'Map'.
            // The 'onAddToCart' passes a function reference to the 'ProductCard' widget and is called when the 'Add To Cart' button is pressed in the 'ProductCard'.
            return ProductCard(
                key: ValueKey(products[index].id),
                product: product as Map<String, dynamic>,
                onAddToCart: widget.onAddToCart);
          },
        );
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Map<String, dynamic>? product;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductCard(
      {Key? key, required this.product, required this.onAddToCart});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.product != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDescription(
                product: widget.product!,
              ),
            ),
          );
        }
      },

            child: Container(
        margin: EdgeInsets.all(4.0),
        height: 750,
        width: 750,
        child: Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 7 / 2,
                  child: Image.network(
                    widget.product?['URL'] ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.product?['Name'] ?? 'Brain Cell',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Center(
                      child: Text(
                        '${widget.product?['Price'] ?? ''}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add the functionality of the button here
                          widget.onAddToCart(widget.product!);
                        },
                        child: Text(
                          "Add To Cart",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 63, 70, 143)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
