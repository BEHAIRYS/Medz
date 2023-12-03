import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AuthScreen_state();
  }
}

class _AuthScreen_state extends State<AuthScreen> {
  var isLogin = true;
  var enteredEmail = '';
  var enteredPassword = '';
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (isLogin) {
      try {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed'),
          ),
        );
      }
    } else {
      try {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        title: const Text(
          'Abohmedz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.background,
              ),
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Email Address'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter valid email address';
                            }
                          },
                          onSaved: (newValue) {
                            enteredEmail = newValue!;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text('Password'),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 8) {
                              return 'Please must be atleast 8 characters long';
                            }
                          },
                          onSaved: (newValue) {
                            enteredPassword = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(isLogin ? 'Login' : 'Sign Up'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin
                              ? 'Create an account'
                              : 'I already Have an account'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
