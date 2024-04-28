import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'detaySayfa.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teknoloji Ürünleri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
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
        title: const Text('Alış-Veriş Uygulaması'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
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

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          8,
              (index) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => detaySayfa(index: index)),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              color: Colors.blueGrey[200],
              child: Center(
                child: Text(
                  'Ürün ${index + 1}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class detaySayfa extends StatelessWidget {
  final int index;

  const detaySayfa({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detay Sayfa'),
      ),
      body: Center(
        child: Text('Detaylar için ürün $index'),
      ),
    );
  }
}

class Mesajlar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mesajlar'),
    );
  }
}

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profil'),
    );
  }
}

class Begendiklerim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Beğendiklerim'),
    );
  }
}
