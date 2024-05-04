import 'package:flutter/material.dart';
import 'main.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FavoritesPage(),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Favoriler'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Favorilenmiş ürünlerin sayısı
              itemBuilder: (context, index) {
                return FavoriteItem();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Favoriden kaldırma işlemi
                  },
                  child: Text('Favorilerden Kaldır'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Paylaşma işlemi
                  },
                  child: Text('Paylaş'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ürün Adı',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Ürün Açıklaması',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            '\$99.99', // Ürün fiyatı
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Ürün resmi
          Image.network(
            'https://via.placeholder.com/150', // Ürün resminin URL'si
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
