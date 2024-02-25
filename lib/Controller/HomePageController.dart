import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomePageController extends GetxController {
  var products = [].obs;
  var filteredProducts = [].obs;
  var cartItems = [].obs;
  double totalPrice = 0;

  late Database database;

  var isDataLoaded = false.obs;

  @override
  void onInit() async {
    await initDatabase();
    fetchProducts();
    fetchCartItems();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products/'));

      if (response.statusCode == 200) {
        products.assignAll(json.decode(response.body));
        filteredProducts.assignAll(products);
        isDataLoaded.value = true;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      isDataLoaded.value = true;
    }
  }

  Future<void> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'cart_database.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Cart(
          id INTEGER PRIMARY KEY,
          title TEXT,
          price REAL,
          description TEXT,
          category TEXT,
          image TEXT,
          rating TEXT
        )
      ''');
    });
  }

  Future<void> fetchCartItems() async {
    final List<Map<String, dynamic>> cartItemsFromDB = await getCartItems();
    cartItems.assignAll(cartItemsFromDB);
    totalPrice = calculateTotalPrice(cartItemsFromDB);
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    await database.insert(
      'Cart',
      {
        'id': product['id'],
        'title': product['title'],
        'price': product['price'],
        'description': product['description'],
        'category': product['category'],
        'image': product['image'],
        'rating': json.encode(product['rating']),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    return await database.query('Cart');
  }

  double calculateTotalPrice(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + item['price']);
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      final List<Map<String, dynamic>> results = [];
      for (final product in products) {
        final String title = product['title'].toString().toLowerCase();
        if (title.contains(query.toLowerCase())) {
          results.add(product);
        }
      }
      filteredProducts.assignAll(results);
    }
  }

  bool isAddedToCart(Map<String, dynamic> product) {
    return cartItems.any((item) => item['id'] == product['id']);
  }

  void addToCart(Map<String, dynamic> product) async {
    await insertProduct(product);
    await fetchCartItems();
  }

  void removeFromCart(Map<String, dynamic> product) async {
    await database.delete(
      'Cart',
      where: 'id = ?',
      whereArgs: [product['id']],
    );
    await fetchCartItems();
  }
}
