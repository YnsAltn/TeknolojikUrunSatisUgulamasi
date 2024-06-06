import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled3/anaSayfa.dart';
import 'profilSayfa2.dart';
import 'urunEkleme.dart';
import 'begendiklerim.dart';
import 'navigationbar.dart'; // Navigation bar widget'ı içeri aktarın

class UrunDetaySayfasi extends StatefulWidget {
  final DocumentSnapshot? product;

  UrunDetaySayfasi({required this.product});

  @override
  _UrunDetaySayfasiState createState() => _UrunDetaySayfasiState();
}

class _UrunDetaySayfasiState extends State<UrunDetaySayfasi> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    checkIfFavorite();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void checkIfFavorite() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final productId = widget.product?.id;
    final DocumentSnapshot? snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .get();
    setState(() {
      _isFavorite = snapshot?.exists ?? false;
    });
  }

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
  }

  void _toggleFavorite() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final productId = widget.product?.id;

    setState(() {
      _isFavorite = !_isFavorite;
    });

    final productData = widget.product?.data() as Map<String, dynamic>?;

    if (_isFavorite) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .set(productData ?? {});
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.product?.data() as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Detayları'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xffB10000),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (productData != null && productData['imageUrls'] != null)
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: productData['imageUrls'].length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      productData['imageUrls'][index],
                      fit: BoxFit.contain,
                    );
                  },
                ),
              )
            else
              Container(
                color: Colors.grey,
                height: 200,
                child: Icon(Icons.image, color: Colors.white),
              ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productData != null && productData.containsKey('category')
                      ? (productData['category'] ?? 'Kategori Bilgisi Yok')
                      : 'Kategori Bilgisi Yok',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                IconButton(
                  icon: _isFavorite
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: _toggleFavorite,
                  color: _isFavorite ? Colors.red : null,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              productData != null && productData.containsKey('brand')
                  ? (productData['brand'] ?? 'Marka Bilgisi Yok')
                  : 'Marka Bilgisi Yok',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Özellikler:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            if (productData != null && productData.containsKey('features'))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.from(
                  (productData['features'] as List).map<Widget>(
                        (feature) => Text('- $feature'),
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              'Açıklama:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              productData != null && productData.containsKey('description')
                  ? (productData['description'] ?? 'Açıklama Yok')
                  : 'Açıklama Yok',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Fiyat: ${productData != null && productData.containsKey('price') ? (productData['price'] ?? 'Bilgi Yok') : 'Bilgi Yok'} TL',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'İletişim Numarası: ${productData != null && productData.containsKey('contactNumber') ? (productData['contactNumber'] ?? 'Bilgi Yok') : 'Bilgi Yok'}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
