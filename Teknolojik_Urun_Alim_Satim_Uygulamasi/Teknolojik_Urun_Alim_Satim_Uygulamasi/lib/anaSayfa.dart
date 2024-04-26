import 'package:flutter/material.dart';
import 'begendiklerim.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({Key? key}) : super(key: key);

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int _selectedIndex = 0;

  // Ürün verileri
  final List<String> urunler = [
    'Ürün 1',
    'Ürün 2',
    'Ürün 3',
    'Ürün 4',
    'Ürün 5',
    'Ürün 6',
    'Ürün 7',
    'Ürün 8',
  ];

  // Ana ekran için sayfa listesi
  final List<Widget> _pages = [
    AnaSayfa(),
    Begendiklerim(),
    Mesajlar(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Alış-Veriş Uygulaması'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Sol menü ikonuna tıklama işlevi buraya eklenebilir

          },
        ),
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
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red[600],
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
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
        backgroundColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Ana sayfa ekranı
class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          8,
              (index) => Container(
            margin: EdgeInsets.all(8),
            color: Colors.blueGrey[200],
            child: Center(
              child: Text(
                'Ürün ${index + 1}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Mesajlar ekranı
class Mesajlar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Beğendiklerim'),
    );
  }
}

// Profil ekranı
class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Mesajlar'),
    );
  }
}

// Beğendiklerim ekranı
class Begendiklerim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profil'),
    );
  }
}
