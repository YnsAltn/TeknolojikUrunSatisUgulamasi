import 'package:flutter/material.dart';
import 'main.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomNavigationMenu(),
    );
  }
}

class CustomNavigationMenu extends StatefulWidget {
  const CustomNavigationMenu({Key? key}) : super(key: key);

  @override
  _CustomNavigationMenuState createState() => _CustomNavigationMenuState();
}

class _CustomNavigationMenuState extends State<CustomNavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ExplorePage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Özel Navigasyon Menüsü'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Arama ikonuna tıklama işlevi buraya eklenebilir
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          color: Colors.grey[200],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Filtreleme Ekranı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Ürün Tipine Göre'),
                onTap: () {
                  // Ürün tipine göre filtreleme işlevi buraya eklenebilir
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Yılına Göre'),
                onTap: () {
                  // Yılına göre filtreleme işlevi buraya eklenebilir
                  Navigator.pop(context);
                },
              ),
              // Filtre türlerini burada arttırabilirsiniz
            ],
          ),
        ),
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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/330px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ürün $index',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Keşfet Sayfası', style: TextStyle(fontSize: 24)),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Favoriler Sayfası', style: TextStyle(fontSize: 24)),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profil Sayfası', style: TextStyle(fontSize: 24)),
    );
  }
}
