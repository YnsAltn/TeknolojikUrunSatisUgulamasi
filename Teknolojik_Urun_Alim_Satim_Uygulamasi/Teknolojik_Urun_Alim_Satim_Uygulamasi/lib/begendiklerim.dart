import 'package:flutter/material.dart';
import 'profilSayfa2.dart';
import 'begendiklerim.dart'; // Beğendiklerim sayfası
import 'anaSayfa.dart';
import 'urunEkleme.dart';
import 'navigationbar.dart'; // Bottom Navigation Bar

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
  int _selectedIndex = 1; // Varsayılan olarak favoriler sekmesini seçili olarak belirle

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        break;
      case 1:
      // Zaten bu sayfadasın, bir şey yapmaya gerek yok
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UrunEklemeFormu()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
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
            child: FavoriteItem(isLarge: true),
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
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class FavoriteItem extends StatefulWidget {
  final bool isLarge;

  const FavoriteItem({required this.isLarge});

  @override
  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imageUrls = [
    'https://via.placeholder.com/300',
    'https://via.placeholder.com/301',
    'https://via.placeholder.com/302',
  ];

  @override
  Widget build(BuildContext context) {
    return widget.isLarge
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _imageUrls.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _imageUrls[index],
                  fit: BoxFit.cover,
                ),
              );
            },
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
                'Ürün Açıklaması',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '\$99.99',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
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
    )
        : Container(
      width: 80, // Ürün kartının genişliği
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
            child: Text(
              'Laptop', // Ürün ismi
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
