import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UrunEklemeFormu extends StatefulWidget {
  @override
  _UrunEklemeFormuState createState() => _UrunEklemeFormuState();
}

class _UrunEklemeFormuState extends State<UrunEklemeFormu> {
  final _formKey = GlobalKey<FormState>();
  late File _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: _selectedImage != null
                ? Image.file(
              _selectedImage,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            )
                : Container(
              width: 150,
              height: 150,
              color: Colors.grey[300],
              child: Icon(
                Icons.camera_alt,
                size: 50,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Ürün Adı',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir ürün adı girin';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Açıklama',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir açıklama girin';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Fiyat',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir fiyat girin';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ürün başarıyla eklendi')),
                );
              }
            },
            child: Text('Ürün Ekle'),
          ),
        ],
      ),
    );
  }
}
