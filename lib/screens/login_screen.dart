import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 10,),
                    ChangeNotifierProvider(create: (_) => LoginFormProvider(),child: _LoginForm(),)
                    
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'usuario@correo.com', 
                labelText: 'Correo Electrónico', 
                prefixIcon: Icons.alternate_email_sharp,),
              onChanged: (value) => loginForm.email = value,
              validator: (value){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
 
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'El valor ingresado no es valido.';
              },
            ),
            SizedBox(height: 30.0,),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '******', 
                labelText: 'Contraseña', 
                prefixIcon: Icons.lock_outline,),
              onChanged: (value) => loginForm.password = value,
              validator: (value){
                if(value != null && value.length >= 6) return null;
                return 'La contraseña debe de ser de minimo 6 caracteres';
              },
            ),
            SizedBox(height: 30.0,),
            MaterialButton(
              onPressed: loginForm.isLoading ? null : () async{
                FocusScope.of(context).unfocus();
                if(!loginForm.isValidForm()) return;
                loginForm.isLoading = true;
                await Future.delayed(Duration(seconds: 2));
                loginForm.isLoading = false;
                Navigator.pushReplacementNamed(context, 'home');
              }, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              color: Colors.deepPurple,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere' :
                  'Ingresar', 
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )),
    );
  }
}