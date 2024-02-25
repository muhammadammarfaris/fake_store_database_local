import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fakestore_api_database/Controller/HomePageController.dart';
import 'package:fakestore_api_database/View/CartPageView.dart';
import 'package:fakestore_api_database/View/DetailPageView.dart';

class HomePageView extends StatelessWidget {
  final HomePageController productController = Get.put(HomePageController());
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.shopping_cart,
    Icons.person,
  ];

  final List<String> _labels = [
    'Home',
    'Cart',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (!productController.isDataLoaded.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: buildProductListView(context),
          );
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildBottomNavBarItems(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, 
        onTap: _onItemTapped,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: buildSearchBar(),
      actions: [
        buildIconButton(Icons.notifications),
        buildIconButton(Icons.mail),
        buildIconButton(Icons.menu),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 36,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 8.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                productController.search(value);
              },
              decoration: InputDecoration(
                hintText: 'Cari Sesuatu?',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconButton buildIconButton(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey),
      onPressed: () {},
    );
  }

  Widget buildProductListView(BuildContext context) {
    final filteredProducts = productController.filteredProducts;
    return ListView.builder(
      itemCount: (filteredProducts.length / 2).ceil(),
      itemBuilder: (context, index) {
        final int productIndex1 = index * 2;
        final int productIndex2 = productIndex1 + 1;
        return Row(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: productIndex1 < filteredProducts.length
                    ? buildProductContainer(
                        context, filteredProducts[productIndex1])
                    : SizedBox(),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: productIndex2 < filteredProducts.length
                    ? buildProductContainer(
                        context, filteredProducts[productIndex2])
                    : SizedBox(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildProductContainer(
      BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Get.to(DetailPageView(product: product));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 120,
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              product['title'],
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.0),
            Text(
              '\$${product['price']}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  productController.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produk ditambahkan ke keranjang'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < _icons.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(_icons[i]),
          label: _labels[i],
        ),
      );
    }
    return items;
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Get.to(() => CartPageView()); 
        break;
      case 2:
        break;
    }
    _selectedIndex = index;
  }
}
