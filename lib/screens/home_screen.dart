import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ProductService productService = Provider.of<ProductService>(context);
    if(productService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index)=>GestureDetector(
          onTap: () {
            productService.selectedProduct = productService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: productService.products[index],)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          productService.selectedProduct = new Product(
            available: true, 
            name: '', 
            price: 0
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}