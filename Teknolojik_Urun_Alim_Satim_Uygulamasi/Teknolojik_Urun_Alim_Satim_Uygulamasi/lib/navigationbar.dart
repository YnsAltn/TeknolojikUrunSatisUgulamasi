import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigationBarWidget({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.red, // navigation bar arka plan rengi
      selectedItemColor: Colors.yellow, // seçili öğelerin ikon ve metin rengi
      unselectedItemColor: Colors.white, // seçili olmayan öğelerin ikon ve metin rengi
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoriler'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ürün Ekle'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
