import 'package:flutter/material.dart';
import 'main.dart';
import 'profilSayfa2.dart';
import 'begendiklerim.dart'; // Beğendiklerim sayfası
import 'urunEkleme.dart';
import 'anaSayfa.dart';
import 'navigationbar.dart'; // Bottom Navigation Bar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Varsayılan olarak profil sekmesini seçili olarak belirle

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UrunEklemeFormu()),
        );
        break;
      case 3:
      // Zaten Profil sayfasındayız, başka bir işlem yapmaya gerek yok
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar'ın arka plan rengini şeffaf yap
        elevation: 0, // AppBar'ın gölgesini kaldır
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Profil'),
      ),
      backgroundColor: Color(0xffB81736), // Scaffold'ın arka plan rengini gradient olarak ayarla
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB81736),
              Color(0xff281537),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/profile_image.png'),
              ),
              SizedBox(height: 20),
              ProfileInfo(icon: Icons.person, label: 'Adı Soyadı', value: 'Kişinin Adı Soyadı'),
              ProfileInfo(icon: Icons.phone, label: 'Numarası', value: 'Kişinin Numarası'),
              ProfileInfo(icon: Icons.email, label: 'Maili', value: 'Kişinin Maili'),
              ProfileInfo(icon: Icons.lock, label: 'Şifresi', value: 'Kişinin Şifresi'),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Çıkış işlemi burada yapılabilir
                },
                child: Text('Çıkış Yap'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
