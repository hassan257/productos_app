import 'package:flutter/cupertino.dart';

class LoginFormProvider extends ChangeNotifier{
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) { 
    _isLoading = value;
    notifyListeners();
  }
}