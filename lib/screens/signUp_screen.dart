import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/http_exceptions.dart';
import '../widgets/decoration_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  var _isloading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_authData['email']!, _authData['password']!);
      Navigator.of(context).pop();
    } on HttpExceptions catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'could not authenticate you. please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
          const Color(0xFF495579),
          const Color(0xFF3C2A21),
        ))),
        SingleChildScrollView(
          child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.1,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 1,
                                offset: Offset(2, 2))
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.050,
                  ),
                  Container(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['email'] = value!;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    labelStyle: const TextStyle(fontSize: 20),
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 5) {
                                    return 'Password is too short!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['password'] = value!;
                                },
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(fontSize: 20),
                                    prefixIcon: const Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.length < 5 ||
                                      value != _passwordController.text) {
                                    return 'passwords don\'t match';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _authData['password'] = value!;
                                },
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    labelText: 'Confirm password',
                                    labelStyle: const TextStyle(fontSize: 20),
                                    prefixIcon: const Icon(Icons.lock_open),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        )),
                  ),
                  Container(
                    width: deviceSize.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        onPressed: _submit,
                        child: _isloading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "SignUp",
                                style: TextStyle(fontSize: 18, shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 1,
                                      offset: Offset(2, 2))
                                ]),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("already have an account!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 1,
                                    offset: Offset(2, 2))
                              ])),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "SignIn now",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 1,
                                      offset: Offset(2, 2))
                                ]),
                          ))
                    ],
                  )
                ],
              )),
        ),
      ]),
    );
  }
}
