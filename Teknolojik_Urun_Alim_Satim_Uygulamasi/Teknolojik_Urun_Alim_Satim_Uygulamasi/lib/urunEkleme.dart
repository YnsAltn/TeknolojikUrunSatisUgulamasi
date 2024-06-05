import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'profilSayfa2.dart';
import 'begendiklerim.dart'; // Beğendiklerim sayfası
import 'anaSayfa.dart';
import 'navigationbar.dart'; // Bottom Navigation Bar

void main() {
  runApp(MaterialApp(
    home: UrunEklemeFormu(),
  ));
}

class UrunEklemeFormu extends StatefulWidget {
  @override
  _UrunEklemeFormuState createState() => _UrunEklemeFormuState();
}

class _UrunEklemeFormuState extends State<UrunEklemeFormu> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final List<String> _categories = [
    'Telefon',
    'Laptop',
    'Tablet',
    'Monitör',
    'Drone',
    'Fotoğraf Makinesi',
    'Diğer'
  ];
  String? _brand;
  final TextEditingController _featureController = TextEditingController();
  final List<String> _features = [];
  String? _description;
  List<XFile> images = [];
  final ImagePicker _picker = ImagePicker();
  String? _contactNumber;
  String? _price;
  int _selectedIndex = 2;

  void _addFeature() {
    final feature = _featureController.text;
    if (feature.isNotEmpty) {
      setState(() {
        _features.add(feature);
      });
      _featureController.clear();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        images.add(pickedFile);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && images.isNotEmpty) {
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final productRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('products')
            .add({
          'category': _selectedCategory,
          'brand': _brand,
          'features': _features,
          'description': _description,
          'contactNumber': _contactNumber,
          'price': _price,
          'imageUrls': [],
        });

        final productId = productRef.id;
        List<String> imageUrls = [];

        await Future.forEach(images, (XFile image) async {
          final imageName = DateTime.now().millisecondsSinceEpoch.toString();
          final uploadTask = FirebaseStorage.instance
              .ref('users/$userId/products/$productId/$imageName')
              .putFile(File(image.path));
          await uploadTask.whenComplete(() async {
            final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
            imageUrls.add(imageUrl);
          });
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('products')
            .doc(productId)
            .update({
          'imageUrls': imageUrls,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün başarıyla eklendi')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _selectedCategory = null;
          _brand = null;
          _features.clear();
          _description = null;
          images.clear();
          _contactNumber = null;
          _price = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün eklenirken bir hata oluştu')),
        );
      }
    } else if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen en az bir resim seçin')),
      );
    }
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(
              File(images[index].path),
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _removeImage(index);
                },
              ),
            ),
          ],
        );
      },
    );
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
// Şu anki sayfada zaten olduğumuz için herhangi bir işlem yapmamıza gerek yok.
        break;
      case 3:
        Navigator.pushReplacement(
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
        title: Center(child: Text('Ürün Ekleme')),
        backgroundColor: Color(0xffB10000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Kategori'),
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir kategori seçin';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Marka-Model',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _brand = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir marka girin';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _featureController,
                decoration: InputDecoration(
                  labelText: 'Özellik Ekle',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addFeature,
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_features.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_features.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _features[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              _removeFeature(index);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              if (images.isNotEmpty)
                Container(
                  height: 200,
                  child: _buildGridView(),
                ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text('Galeriden Resim Seç'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Kamera ile Resim Çek'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'İletişim Numarası',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _contactNumber = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir iletişim numarası girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fiyat',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _price = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir fiyat girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ürün Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
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
