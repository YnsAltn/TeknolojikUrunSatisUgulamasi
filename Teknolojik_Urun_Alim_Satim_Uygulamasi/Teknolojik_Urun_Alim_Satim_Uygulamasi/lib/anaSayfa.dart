import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profilSayfa2.dart';
import 'urunEkleme.dart';
import 'begendiklerim.dart';
import 'navigationbar.dart';
import 'detaySayfa.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 0;
  String _selectedCategory = 'Tüm Ürünler';
  Stream<QuerySnapshot>? _productStream;

  @override
  void initState() {
    super.initState();
    _productStream ??= _fetchProducts();
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

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _productStream = _fetchProducts();
    });
    Navigator.of(context).pop();
  }

  Stream<QuerySnapshot> _fetchProducts() {
    Stream<QuerySnapshot> productsStream;

    if (_selectedCategory == 'Tüm Ürünler') {
      productsStream = _firestore.collectionGroup('products').snapshots();
    } else {
      productsStream = _firestore.collectionGroup('products')
          .where('category', isEqualTo: _selectedCategory)
          .snapshots();
    }

    return productsStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('    Alış-Veriş Uygulaması'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(_firestore, _selectedCategory),
              );
            },
          ),
        ],
        backgroundColor: Color(0xffB10000),
      ),
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Filtreleme Seçenekleri',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff5C1635),
                ),
              ),
              ListTile(
                title: Text('Tüm Ürünler'),
                onTap: () {
                  _filterByCategory('Tüm Ürünler');
                },
              ),
              ListTile(
                title: Text('Telefon'),
                onTap: () {
                  _filterByCategory('Telefon');
                },
              ),
              ListTile(
                title: Text('Laptop'),
                onTap: () {
                  _filterByCategory('Laptop');
                },
              ),
              ListTile(
                title: Text('Tablet'),
                onTap: () {
                  _filterByCategory('Tablet');
                },
              ),
              ListTile(
                title: Text('Monitör'),
                onTap: () {
                  _filterByCategory('Monitör');
                },
              ),
              ListTile(
                title: Text('Drone'),
                onTap: () {
                  _filterByCategory('Drone');
                },
              ),
              ListTile(
                title: Text('Fotoğraf Makinesi'),
                onTap: () {
                  _filterByCategory('Fotoğraf makinesi');
                },
              ),
              ListTile(
                title: Text('Diğer'),
                onTap: () {
                  _filterByCategory('Diğer');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB10000),
              Color(0xff281537),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _productStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Hiç ürün yok'));
              } else {
                final products = snapshot.data!.docs;
                return GridView.builder(
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

                    return GestureDetector(
                      onTap: () {
                        _navigateToProductDetail(product);
                      },
                      child: Card(
                        color: Color(0xffF4F4F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: getImageWidget(productData),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['category'] ?? 'Kategori',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0F1A2F),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    productData['brand'] ?? 'Marka Yok',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4),
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
              }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget getImageWidget(Map<String, dynamic> productData) {
    final List<String> imageUrls = productData.containsKey('imageUrls')
        ? List<String>.from(productData['imageUrls'])
        : [];
    return imageUrls.isNotEmpty
        ? Image.network(
      imageUrls.first,
      fit: BoxFit.cover,
    )
        : Container(
      color: Colors.grey,
      child: Icon(Icons.image, color: Colors.white),
    );
  }

  void _navigateToProductDetail(QueryDocumentSnapshot product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UrunDetaySayfasi(product: product),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final FirebaseFirestore firestore;
  final String selectedCategory;

  ProductSearchDelegate(this.firestore, this.selectedCategory);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collectionGroup('products')
          .where('category', isEqualTo: selectedCategory)
          .where('brand', isGreaterThanOrEqualTo: query)
          .where('brand', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Arama sonucunda ürün bulunamadı.'));
        }

        final products = snapshot.data!.docs;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final productData = product.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(productData['name'] ?? 'Ürün Adı Yok'),
              subtitle: Text(productData['category'] ?? 'Kategori Yok'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunDetaySayfasi(product: product),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
