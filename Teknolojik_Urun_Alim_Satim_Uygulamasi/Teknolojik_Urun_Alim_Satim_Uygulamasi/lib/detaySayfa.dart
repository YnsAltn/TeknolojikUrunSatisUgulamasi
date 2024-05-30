import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UrunDetaySayfasi extends StatelessWidget {
  final DocumentSnapshot? product;

  UrunDetaySayfasi({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Detayları'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product != null && (product!.data() as Map)['imagePaths'] != null)
              Container(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  (product!.data() as Map)['imagePaths'][0],
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              product != null && (product!.data() as Map).containsKey('brand') ? ((product!.data() as Map)['brand'] ?? 'Marka Bilgisi Yok') : 'Marka Bilgisi Yok',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              product != null && (product!.data() as Map).containsKey('category') ? ((product!.data() as Map)['category'] ?? 'Kategori Bilgisi Yok') : 'Kategori Bilgisi Yok',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
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
            if (product != null && (product!.data() as Map).containsKey('features'))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.from((product!.data() as Map)['features'].map<Widget>((feature) => Text('- $feature'))),
              ),
            SizedBox(height: 16.0),
            Text(
              product != null && (product!.data() as Map).containsKey('description') ? ((product!.data() as Map)['description'] ?? 'Açıklama Yok') : 'Açıklama Yok',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Fiyat: ${product != null && (product!.data() as Map).containsKey('price') ? ((product!.data() as Map)['price'] ?? 'Bilgi Yok') : 'Bilgi Yok'} TL',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'İletişim Numarası: ${product != null && (product!.data() as Map).containsKey('contactNumber') ? ((product!.data() as Map)['contactNumber'] ?? 'Bilgi Yok') : 'Bilgi Yok'}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
