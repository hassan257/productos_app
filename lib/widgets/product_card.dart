import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    Key? key,
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
          _BackgroundImage(url: product.picture),
          _ProductsDetails(name: product.name, id: product.id!,),
          Positioned(
            top: 0,
            right: 0,
            child: _PriceTag(price: product.price)
          ),
          if(!product.available)
            Positioned(
              top: 0,
              left: 0,
              child: _NotAvailable(available: product.available)
            ),
        ],),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 7),
        ),]
      );
  }
}

class _NotAvailable extends StatelessWidget {

  final bool available;

  const _NotAvailable({
    Key? key,
    required this.available
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text((!available) ? 'No disponible' : 'Disponible', style: TextStyle(color: Colors.white, fontSize: 20),),),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(color: Colors.yellow[800], borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag({
    Key? key,
    required this.price
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$${price.toString()}', style: TextStyle(color: Colors.white, fontSize: 20),)),
      ),
        
      width: 100,
      height: 70,
      decoration: BoxDecoration(color: Colors.indigo,borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomLeft: Radius.circular(25))),
    );
  }
}

// ignore: must_be_immutable
class _BackgroundImage extends StatelessWidget {

  String? url;

  _BackgroundImage({
    this.url
  });

  @override
  Widget build(BuildContext context) {
    // if(url == null) url = 'https://via.placeholder.com/400x300/f6f6f6';
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        color: Colors.red,
        child: (url == null) ? Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover,) :
        FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(url!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ProductsDetails extends StatelessWidget {

  final String name;
  final String id;

  const _ProductsDetails({
    Key? key,
    required this.name,
    required this.id
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        // color: Colors.indigo,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${this.name}', style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,),
            Text('${this.id}', style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),

  );
}