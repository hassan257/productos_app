import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ProductService productService = Provider.of<ProductService>(context);
    // return _ProductScreenBody(productService: productService);
    return ChangeNotifierProvider(create: (_) => ProductFormProvider(productService.selectedProduct),
    child: _ProductScreenBody(productService: productService),);
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final ProductFormProvider productFormProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: ()async{
          if(!productFormProvider.isValidForm()) return;
          
          await productService.saveOrCreateProduct(productFormProvider.product);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(children: [
              ProductImage(url: productService.selectedProduct.picture,),
              Positioned(
                child: IconButton(
                  color: Colors.white, 
                  onPressed: () => Navigator.of(context).pop(), 
                  icon: Icon(Icons.arrow_back_ios_new),),
                top: 60,
                left: 20,
              ),
              Positioned(
                child: IconButton(
                  color: Colors.white, 
                  onPressed: () async{
                    final picker = new ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100
                    );
                    if(pickedFile == null){
                      print('No se selecciono nada');
                      return;
                    }
                    print('Tenemos imágen ${pickedFile.path}');
                    productService.updateSelectedProductImage(pickedFile.path);
                  }, 
                  icon: Icon(Icons.camera_alt_outlined),),
                top: 60,
                right: 20,
              ),
            ],),
            _ProductForm(),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
          children: [
            SizedBox(height: 10,),
            TextFormField(
              initialValue: product.name,
              onChanged: (value) => product.name = value,
              validator: (value){
                if(value == null || value.length < 1)
                  return 'El nombre es obligatorio';
              },
              decoration: InputDecorations.authInputDecoration(hintText: 'Nombre del Producto', labelText: 'Nombre:'),
            ),
            SizedBox(height: 30,),
            TextFormField(
              initialValue: product.price.toString(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              onChanged: (value) { 
                if(double.tryParse(value) == null){
                  product.price = 0;
                }else{
                  product.price = double.parse(value);

                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(hintText: '\$150.00', labelText: 'Precio:'),
            ),
            SizedBox(height: 30,),
            SwitchListTile.adaptive(
              title: Text('Disponible'),
              value: product.available, 
              onChanged: productForm.updateAvailability),
            SizedBox(height: 30,),
          ],
        )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: Offset(0,5),
          blurRadius: 5
        )
      ]
    );
  }
}