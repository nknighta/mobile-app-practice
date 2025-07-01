import 'package:flutter/material.dart';
import 'package:mobile_app_class/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignIn ? 'Sign In' : 'Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result;
                    if (isSignIn) {
                      result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() => error = 'Could not sign in with those credentials');
                      }
                    } else {
                      result = await _auth.signUpWithEmailAndPassword(email, password);
                       if (result == null) {
                        setState(() => error = 'Please supply a valid email');
                      }
                    }
                  }
                },
              ),
              TextButton(
                child: Text(isSignIn
                    ? 'Need an account? Sign up'
                    : 'Have an account? Sign in'),
                onPressed: () {
                  setState(() {
                    isSignIn = !isSignIn;
                    error = '';
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Sign in with Google'),
                onPressed: () async {
                  dynamic result = await _auth.signInWithGoogle();
                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to sign in with Google. This feature is only available on mobile devices.'),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
