import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<String> categories = [
    'Telefon',
    'Laptop',
    'Tablet',
    'Monitör',
    'Drone',
    'Fotoğraf Makinesi',
    'Televizyon'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Kategorileri'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
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
                  builder: (context) => KategoriSayfasi(
                    kategori: categories[index],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UrunEklemeFormu()),
            );
          }
        },
      ),
    );
  }
}

class KategoriSayfasi extends StatelessWidget {
  final String kategori;

  KategoriSayfasi({required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$kategori Kategorisi'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          '$kategori ürünleri burada listelenecek.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
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
    'Televizyon'
  ];

  List<String> _subCategories = [];
  String? _selectedSubCategory;
  final Map<String, List<String>> _categoryMap = {
    'Telefon': ['Akıllı Telefon', 'Klasik Telefon'],
    'Laptop': ['Oyun Laptopu', 'İş Laptopu', 'Ultra Taşınabilir'],
    'Tablet': ['Android Tablet', 'iOS Tablet'],
    'Monitör': ['LCD', 'LED', 'OLED'],
    'Drone': ['Kamera Drone', 'Yarış Drone'],
    'Fotoğraf Makinesi': ['DSLR', 'Mirrorless', 'Kompakt'],
    'Televizyon': ['LED TV', 'OLED TV', 'QLED TV']
  };

  List<XFile> images = <XFile>[];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        images.addAll(pickedFiles);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
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

  void _submitForm() {
    if (_formKey.currentState!.validate() && images.isNotEmpty) {
      // Ürün bilgilerini ve resimlerini kaydedin veya işleyin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün başarıyla eklendi')),
      );

      // Formu sıfırla
      _formKey.currentState!.reset();
      setState(() {
        _selectedCategory = null;
        _selectedSubCategory = null;
        images.clear();
      });
    } else if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen en az bir resim seçin')),
      );
    }
  }

  Widget _buildGridView() {
    return GridView.builder(
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
                    _subCategories = _categoryMap[_selectedCategory!] ?? [];
                    _selectedSubCategory = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir kategori seçin';
                  }
                  return null;
                },
              ),
              if (_subCategories.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Alt Kategori'),
                  value: _selectedSubCategory,
                  items: _subCategories.map((String subCategory) {
                    return DropdownMenuItem<String>(
                      value: subCategory,
                      child: Text(subCategory),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSubCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir alt kategori seçin';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ürün Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir ürün adı girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir fiyat girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              images.isNotEmpty
                  ? Container(
                height: 200,
                child: _buildGridView(),
              )
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: Icon(Icons.photo_library),
                label: Text('Galeriden Resim Seç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImageFromCamera,
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
