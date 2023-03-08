import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_starting_project/components/rounded_button.dart';
import 'package:flash_chat_starting_project/screens/chat_screen.dart';
import 'package:flash_chat_starting_project/services/auth_serviec.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:flash_chat_starting_project/services/auth_serviec.dart';
import '/constants.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {

  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();

}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey <FormState> _formkey = GlobalKey<FormState>();
  var auth = FirebaseAuth.instance;
  String errorMessage ='';
  bool errorOcured = false, showSpinner = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: KTextFieldDecoration.copyWith(
                          hintText: 'Enter Your email',
                          labelText: 'email'
                      ),
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email){
                        return email != null && EmailValidator.validate(email) ? null : 'please enter a valid email';
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                    Form(
                      child: TextFormField(
                        decoration: KTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Password',
                            labelText: 'password'
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        onChanged: (value) {
                          //Do something with the user input
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password){
                          return password != null && password.length >5 ?null :'the password should be at least 5 charecters';
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: errorOcured,
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              RoundedButton(
                  color: kRegisterButtonColor,
                  title: 'Register',
                  onPressed: () async {
                    if(_formkey.currentState!.validate()) {
                      try {
                        setState(() {
                          errorOcured = false;
                          showSpinner = true;
                        });
                        await AuthService().
                        createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ).then((value) {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ChatScreen.id);
                        });
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print('Error ${e.toString()}');
                        setState(() {
                          showSpinner = false;
                          errorOcured = true;
                          errorMessage = e.toString().split('] ')[1];
                        });
                      }
                    }
                  }
              ),
              const SizedBox(height: 12),

              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
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
