import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getProducts() async {
  List<Map<String, dynamic>> productsList = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('products').get();

    querySnapshot.docs.forEach((doc) {
      productsList.add(doc.data());
    });

    return productsList;
  } catch (e) {
    print("Error fetching products: $e");
    return [];
  }
}
