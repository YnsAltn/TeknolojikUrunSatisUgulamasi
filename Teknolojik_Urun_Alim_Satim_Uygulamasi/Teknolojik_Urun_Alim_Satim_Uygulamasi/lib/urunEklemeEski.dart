import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(MaterialApp(
    home: UrunEklemeFormu(),
  ));
}

class UrunEklemeFormu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Kategorileri'),
        backgroundColor: Colors.teal,
      ),
      body: CategoriesList(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

class CategoriesList extends StatelessWidget {
  final List<String> categories = [
    'Telefon',
    'Laptop',
    'Tablet',
    'Monitör',
    'Drone',
    'Fotoğraf Makinesi',
    'Diğer'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            categories[index],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryPage(
                  category: categories[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddProductPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Ürün Ekle',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      onTap: _onItemTapped,
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Kategorisi'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          '$category ürünleri burada listelenecek.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
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

  void _submitForm() async {
    if (_formKey.currentState!.validate() && images.isNotEmpty) {
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        final productRef = await FirebaseFirestore.instance.collection('users').doc(userId).collection('products').add({
          'category': _selectedCategory,
          'brand': _brand,
          'features': _features,
          'description': _description,
        });

        final productId = productRef.id;

        await Future.forEach(images, (XFile image) async {
          final imageName = DateTime.now().millisecondsSinceEpoch.toString();
          await FirebaseStorage.instance.ref('users/$userId/products/$productId/$imageName').putFile(File(image.path));
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
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün eklenirken bir hata oluştu')),
        );
      }
    } else if (images.isEmpty) {
      ScaffoldMessenger.of
        (context).showSnackBar(
        SnackBar(content: Text('Lütfen en az bir resim seçin')),
      );
    }
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Ekle'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
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
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Marka',
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
                  children: _features.map((feature) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        feature,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
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
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text('Galeriden Resim Seç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt),
                label: Text('Kamera ile Resim Çek'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
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
    );
  }
}


