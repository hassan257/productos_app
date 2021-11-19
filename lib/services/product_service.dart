import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier{
  final String _baseUrl = 'flutter-varios-d8cf6-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;

  ProductService(){
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async{
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) { 
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });
    this.isLoading = false;
    notifyListeners();
    return this.products;
  }

  Future saveOrCreateProduct(Product product) async{
    isSaving = true;
    notifyListeners();

    if(product.id == null){
      await createProduct(product);
    }else{
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async{
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;
    print(decodedData);
    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;
    return product.id!;
  }

  Future<String> createProduct(Product product) async{
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    this.products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path){
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

}