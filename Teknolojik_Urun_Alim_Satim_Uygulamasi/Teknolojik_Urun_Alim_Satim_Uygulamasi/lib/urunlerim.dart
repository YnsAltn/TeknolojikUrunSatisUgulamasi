import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UrunlerimSayfasi extends StatefulWidget {
  @override
  _UrunlerimSayfasiState createState() => _UrunlerimSayfasiState();
}

class _UrunlerimSayfasiState extends State<UrunlerimSayfasi> {
  late Future<List<DocumentSnapshot>> _urunlerim;

  @override
  void initState() {
    super.initState();
    _urunlerim = fetchUrunlerim();
  }

  Future<List<DocumentSnapshot>> fetchUrunlerim() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('products')
          .get();
      return querySnapshot.docs;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünlerim'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xffB10000),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _urunlerim,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<DocumentSnapshot>? urunlerim = snapshot.data;
            return urunlerim != null && urunlerim.isNotEmpty
                ? ListView.builder(
              itemCount: urunlerim.length,
              itemBuilder: (context, index) {
                final productData = urunlerim[index].data() as Map<String, dynamic>;
                final List<dynamic> imageUrls = productData['imageUrls'] ?? [];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(productData['category'] ?? 'Kategori'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productData['brand'] ?? 'Ürün Adı'),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                            ),
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index) {
                              final imageUrl = imageUrls[index];
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await urunlerim[index].reference.delete();
                        setState(() {
                          _urunlerim = fetchUrunlerim(); // Listeyi güncelle
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ürün silindi')));
                      },
                    ),
                  ),
                );
              },
            )
                : Center(child: Text('Hiç ürün eklememişsiniz.'));
          }
        },
      ),
    );
  }
}
