// CartPageView.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fakestore_api_database/Controller/HomePageController.dart';

class CartPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      builder: (productController) {
        final isCartLoaded = productController.isDataLoaded.value; // Gunakan RxBool untuk memantau status pemuatan item keranjang

        return Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: isCartLoaded
              ? Obx(() {
                  final cartItems = productController.cartItems;
                  return cartItems.isEmpty
                      ? Center(
                          child: Text('Tidak ada barang yang dimasukan ke keranjang'))
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(item['image']),
                                  ),
                                  title: Text(
                                    item['title'],
                                    style: TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '\$${item['price']}',
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 14.0),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      productController.removeFromCart(item);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                })
              : Center(child: CircularProgressIndicator()), // Tampilkan indicator jika item keranjang belum dimuat
          bottomNavigationBar: BottomAppBar(
            elevation: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${productController.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                    ),
                    child:
                        Text('Checkout', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
