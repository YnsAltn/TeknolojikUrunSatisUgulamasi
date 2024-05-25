import 'package:flutter/material.dart';
import 'begendiklerim.dart';
import 'profilSayfa2.dart';
import 'forgotPassword.dart';
import 'urunEkleme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teknoloji Ürünleri',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xffF4F4F4), // Arka plan rengi
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> products = [
    {'name': 'Ürün 1', 'price': '100 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 2', 'price': '200 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 3', 'price': '300 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 4', 'price': '400 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 5', 'price': '500 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 6', 'price': '600 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 7', 'price': '700 TL', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Ürün 8', 'price': '800 TL', 'image': 'https://via.placeholder.com/150'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Alış-Veriş Uygulaması'),
        leading: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        backgroundColor: Color(0xffB10000), // AppBar rengi
      ),
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Filtreleme Seçenekleri'),
                decoration: BoxDecoration(
                  color: Color(0xff5C1635), // DrawerHeader arka plan rengi
                ),
              ),
              ListTile(
                title: Text('Fiyat Aralığı'),
                onTap: () {
                  // Fiyat aralığı filtresi işlevi buraya eklenecek
                },
              ),
              ListTile(
                title: Text('Kategori'),
                onTap: () {
                  // Kategori filtresi işlevi buraya eklenecek
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB10000), // Koyu Kırmızı
              Color(0xff281537), // Siyah
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                // Ürün detay sayfasına geçiş işlemi burada gerçekleştirilecek
              },
              child: Card(
                color: Color(0xffF4F4F4), // Card arka plan rengi
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        product['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name']!,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0F1A2F), // Başlık rengi
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            product['price']!,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600], // Metin rengi
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Beğendiklerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffB10000), // Seçili öğe rengi
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
            // Ana sayfaya git
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
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
        },
        backgroundColor: Color(0xffF4F4F4), // BottomNavigationBar arka plan rengi
      ),
    );
  }
}
