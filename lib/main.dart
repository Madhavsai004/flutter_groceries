import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Item {
  String name;
  double price;
  bool selected;

  Item(this.name, this.price, {this.selected = false});
}

class ShoppingCart {
  List<Item> items = [];
}

class MyApp extends StatelessWidget {
  final ShoppingCart cart = ShoppingCart();
  final List<Item> vegetableList = [
    Item('Carrot', 5.0),
    Item('Broccoli', 4.0),
    Item('Tomato', 3.0),
    // Add more vegetables as needed
  ];
  final List<Item> fruitList = [
    Item('Apple', 2.0),
    Item('Banana', 1.5),
    Item('Orange', 3.0),
    // Add more fruits as needed
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('🛒 Shopping Cart App'),
          backgroundColor: Colors.green,
        ),
        body: ShoppingCartPage(cart: cart, vegetableList: vegetableList, fruitList: fruitList),
      ),
    );
  }
}

class ShoppingCartPage extends StatelessWidget {
  final ShoppingCart cart;
  final List<Item> vegetableList;
  final List<Item> fruitList;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  ShoppingCartPage({required this.cart, required this.vegetableList, required this.fruitList});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 4, 
      itemBuilder: (context, index) {
        if (index == 0) {
          return StartShoppingPage(onStartShopping: () {
            _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        } else if (index == 1) {
          return ItemListPage(
            itemList: vegetableList,
            cart: cart,
            onNext: () {
              _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
            onCancel: () {
              _pageController.jumpToPage(0); 
            },
          );
        } else if (index == 2) {
          return ItemListPage(
            itemList: fruitList,
            cart: cart,
            onNext: () {
              _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
            onCancel: () {
              _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          );
        } else {
          return CheckoutPage(cart: cart, onCancel: () {
            _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        }
      },
      onPageChanged: (index) {
        _currentPage = index;
      },
    );
  }
}

class StartShoppingPage extends StatelessWidget {
  final Function onStartShopping;

  StartShoppingPage({required this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => onStartShopping(),
          child: Text('Start Shopping 🛍️', style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}

class ItemListPage extends StatefulWidget {
  final List<Item> itemList;
  final ShoppingCart cart;
  final Function onNext;
  final Function onCancel;

  ItemListPage({required this.itemList, required this.cart, required this.onNext, required this.onCancel});

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Items:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            for (var item in widget.itemList)
              ListTile(
                title: Text('${item.name} - \$${item.price} per kg', style: TextStyle(fontSize: 16)),
                tileColor: item.selected ? Colors.green.withOpacity(0.5) : null,
                onTap: () {
                  setState(() {
                    if (!item.selected) {
                      widget.cart.items.add(item);
                    } else {
                      widget.cart.items.remove(item);
                    }
                    item.selected = !item.selected;
                  });
                },
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => widget.onCancel(),
                  child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () => widget.onNext(),
                  child: Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final ShoppingCart cart;
  final Function onCancel;

  CheckoutPage({required this.cart, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    double total = cart.items.map((item) => item.price).fold(0, (a, b) => a + b);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Items in Cart:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            for (var item in cart.items) Text('${item.name} - \$${item.price} per kg', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => onCancel(),
                  child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                   
                  },
                  child: Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}