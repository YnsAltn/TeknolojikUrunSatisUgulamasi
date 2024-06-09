import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profilSayfa2.dart';
import 'anaSayfa.dart';
import 'urunEkleme.dart';
import 'navigationbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FavoritesPage(),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int _selectedIndex = 1;

  late Future<List<DocumentSnapshot>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = fetchFavorites();
  }

  Future<List<DocumentSnapshot>> fetchFavorites() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .get();
      return querySnapshot.docs;
    } else {
      return [];
    }
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('                Favoriler'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final List<DocumentSnapshot>? favorites = snapshot.data;
            return favorites != null && favorites.isNotEmpty
                ? ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favoriteData = favorites[index].data() as Map<String, dynamic>;
                final List<dynamic> imageUrls = favoriteData['imageUrls'] ?? [];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          favoriteData['brand'] ?? 'Ürün Adı',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index) {
                              final imageUrl = imageUrls[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          favoriteData['description'] ?? 'Ürün Açıklaması',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${favoriteData['price'] ?? 'Fiyat'} TL',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No: ${favoriteData['contactNumber'] ?? 'Fiyat'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await favorites[index].reference.delete();
                                setState(() {
                                  _favorites = fetchFavorites();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Favori üründen kaldırıldı')));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Center(child: Text('Favori ürününüz bulunmamaktadır.'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
