import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'begendiklerim.dart'; // Beğendiklerim sayfası
import 'urunEkleme.dart';
import 'anaSayfa.dart';
import 'navigationbar.dart'; // Bottom Navigation Bar
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication eklendi
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore eklendi
import 'urunlerim.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage eklendi
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
  final FirebaseStorage _storage = FirebaseStorage.instance;

  int _selectedIndex = 3;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
    _getUserPhoneNumber();
    _emailController.text = _auth.currentUser!.email ?? '';
  }

  void _getUserDisplayName() async {
    setState(() {
      _nameController.text = _auth.currentUser!.displayName ?? '';
    });
  }

  void _getUserPhoneNumber() async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    setState(() {
      _phoneController.text = doc['phoneNumber'] ?? '';
    });
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
        break;
    }
  }

  Future<void> _updateProfileInfo() async {
    await _auth.currentUser!.updateDisplayName(_nameController.text);
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
        {'phoneNumber': _phoneController.text, 'name': _nameController.text});

    if (_imageFile != null) {
      final Reference storageRef =
          _storage.ref().child('profile_photos/${_auth.currentUser!.uid}');
      await storageRef.putFile(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Profil'),
      ),
      backgroundColor: Color(0xffB81736),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(File('dosya_yolu')),
                  ),

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
                SizedBox(height: 16),
                ProfileInfo(
                  label: 'Telefon Numarası',
                  value: _phoneController.text,
                  onChanged: (value) {
                    setState(() {
                      _phoneController.text = value;
                    });
                  },
                ),
                SizedBox(height: 16),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UrunlerimSayfasi()),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 85),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
