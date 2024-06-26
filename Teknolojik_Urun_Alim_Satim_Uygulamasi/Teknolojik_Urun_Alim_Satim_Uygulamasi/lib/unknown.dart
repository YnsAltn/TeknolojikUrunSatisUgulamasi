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

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int _selectedIndex = 2; // Varsayılan olarak favoriler sekmesini seçili olarak belirle

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Favorilenmiş ürünlerin sayısı (üst kısım)
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: FavoriteItem(isLarge: true),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // Favorilenmiş ürünlerin sayısı (alt kısım)
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: FavoriteItem(isLarge: false),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.red, // navigation bar arka plan rengi
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.red, // navigation bar arka plan rengi
          selectedItemColor: Colors.yellow, // seçili öğelerin ikon ve metin rengi
          unselectedItemColor: Colors.white, // seçili olmayan öğelerin ikon ve metin rengi
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Keşfet'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoriler'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final bool isLarge;

  const FavoriteItem({required this.isLarge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isLarge ? MediaQuery.of(context).size.width * 0.75 : 80, // Ürün kartının genişliği
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://via.placeholder.com/300', // Ürün resminin URL'si
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ürün Adı',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  isLarge ? 'Ürün Açıklaması' : '\$99.99', // Ürün açıklaması (üst kısım) veya fiyatı (alt kısım)
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          if (isLarge)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    // Favoriden kaldırma işlemi
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Paylaşma işlemi
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
