import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_starting_project/components/rounded_button.dart';
import 'package:flash_chat_starting_project/services/auth_serviec.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '/constants.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_Screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String errorMessage = " ";
  bool errorOcurred = false , showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField
                      (
                      decoration: KTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email){
                        return email != null && EmailValidator.validate(email) ? null :
                        'Please enter a valid email';
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: KTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                        labelText: 'password',
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) {
                        return password != null && password.length > 5
                            ? null
                            : 'The password should be of 6 characters at least';
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24.0,
              ),
              Visibility(
                visible: errorOcurred,
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              RoundedButton(color: kLoginButtonColor, title: 'Log In', onPressed: (){}),
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async{
                  if (_formkey.currentState!.validate()) {
                    try {
                      setState((){
                        errorOcurred =false;
                        showSpinner = true;

                      });
                      await AuthService().signWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ChatScreen.id);
                      });
                      setState((){
                        showSpinner = false;
                      });
                    } catch (e) {
                      print('ERROR ${e.toString()}');
                      setState(() {
                        showSpinner = false;
                        errorOcurred = true;
                        errorMessage = e.toString().split('] ')[1];
                      });
                    }
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
