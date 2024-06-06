import 'package:flutter/material.dart';
import 'main.dart';
import 'profilSayfa2.dart';
import 'begendiklerim.dart'; // Beğendiklerim sayfası
import 'urunEkleme.dart';
import 'anaSayfa.dart';
import 'navigationbar.dart'; // Bottom Navigation Bar
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication eklendi
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore eklendi
import 'urunlerim.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 3; // Varsayılan olarak profil sekmesini seçili olarak belirle

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Kullanıcı verilerini çek ve ilgili controller'lara ata
    _nameController.text = _auth.currentUser!.displayName ?? '';
    _phoneController.text = ''; // Telefon numarası Firestore'dan alınacak
    _emailController.text = _auth.currentUser!.email ?? '';
    _getUserPhoneNumber();
  }

  void _getUserPhoneNumber() async {
    // Firestore'dan telefon numarasını al
    DocumentSnapshot doc =
    await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    setState(() {
      _phoneController.text = doc['phoneNumber'] ?? '';
    });
  }

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

  void _updateProfileInfo() async {
    // Kullanıcının adını Firestore'da güncelle
    await _auth.currentUser!.updateDisplayName(_nameController.text);
    // Kullanıcının telefon numarasını Firestore'da güncelle
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'phoneNumber': _phoneController.text});
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
      body: SingleChildScrollView(
        child: Container(
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
                ProfileInfo(
                  label: 'Adı Soyadı',
                  value: _nameController.text,
                  onChanged: (value) {
                    setState(() {
                      _nameController.text = value;
                    });
                  },
                ),
                ProfileInfo(
                  label: 'Telefon Numarası',
                  value: _phoneController.text,
                  onChanged: (value) {
                    setState(() {
                      _phoneController.text = value;
                    });
                  },
                ),
                ProfileInfo(
                  label: 'E-mail',
                  value: _emailController.text,
                  onChanged: (value) {
                    setState(() {
                      _emailController.text = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateProfileInfo();
                  },
                  child: Text('Bilgileri Güncelle'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Ürünlerim sayfasına git
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>UrunlerimSayfasi()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Ürünlerim',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
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
  final String label;
  final String value;
  final Function(String) onChanged;

  const ProfileInfo({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 33),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: TextEditingController(text: value),
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
