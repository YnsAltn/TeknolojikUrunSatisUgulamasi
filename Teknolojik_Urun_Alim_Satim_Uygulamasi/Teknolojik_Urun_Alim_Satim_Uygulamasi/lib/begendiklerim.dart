import 'package:flutter/material.dart';
import 'main.dart'; // begendiklerim.dart dosyasını import ediyoruz

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
    Mesajlar(),
    Profil(),
    BegendiklerimPage(), // BegendiklerimPage'ı ekledik
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alış-Veriş Uygulaması'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Beğendiklerim'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mesajlar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class BegendiklerimPage extends StatefulWidget {
  const BegendiklerimPage({super.key});

  @override
  State<BegendiklerimPage> createState() => _BegendiklerimPageState();
}

class _BegendiklerimPageState extends State<BegendiklerimPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ana Sayfa'),
    );
  }
}

class Mesajlar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Mesajlar'),
    );
  }
}

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profil'),
    );
  }
}
