import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detaySayfa.dart';
import 'navigationbar.dart';
import 'begendiklerim.dart';
import 'profilSayfa2.dart';
import 'urunEkleme.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<String>> _getImageUrls(List<String> paths) async {
    List<String> urls = [];
    for (String path in paths) {
      final url = await FirebaseStorage.instance.ref(path).getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Ana sayfada kal
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collectionGroup('products')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text('Hiç ürün yok'));
            }

            final products = snapshot.data!.docs;

            return GridView.builder(
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
                final productData = product.data() as Map<String, dynamic>;

                final imagePaths =
                    List<String>.from(productData['imagePaths'] ?? []);

                return FutureBuilder<List<String>>(
                  future: _getImageUrls(imagePaths),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!imageSnapshot.hasData) {
                      return Center(child: Text('Resim yüklenemedi'));
                    }

                    final imageUrls = imageSnapshot.data!;
                    final firstImageUrl =
                        imageUrls.isNotEmpty ? imageUrls.first : '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UrunDetaySayfasi(product: product),
                          ),
                        );
                      },
                      child: Card(
                        color: Color(0xffF4F4F4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: firstImageUrl.isNotEmpty
                                  ? Image.network(
                                      firstImageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/profile_image.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['name'] ?? 'Ürün Adı Yok',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0F1A2F),
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    productData['brand'] ?? 'Marka Yok',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    productData['price'] != null
                                        ? '${productData['price']} TL'
                                        : 'Fiyat Yok',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
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
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
