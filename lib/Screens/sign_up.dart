import 'package:admin/Constants/design.dart';
import 'package:admin/Screens/admin_page.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();
  late bool _obscureText = true;
  late IconData _icon = Icons.lock_outline;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    final authInstance = context.read<FirebaseAuth>();
    bool busy = false;
    ValueNotifier busyVal = ValueNotifier(busy);
    return ValueListenableBuilder(
      valueListenable: busyVal,
      builder: (BuildContext context, value, Widget? child) {
        return value == true ? const Center(child: CircularProgressIndicator(),) : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            iconTheme: IconThemeData(color: Colors.blue[800]),
            elevation: 0,
          ),
          body: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/divaz_logo.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                  fit: BoxFit.cover,
                ),
                Form(
                    key: _signUpKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.1),
                          child: Text(
                            'ADMIN SIGN UP',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w800,
                                fontSize: MediaQuery.of(context).size.shortestSide *
                                    0.04),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.01),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              color: Colors.grey[300],
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid email address.';
                                  } else {
                                    email = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email),
                                  hintText: 'Email',
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                      const BorderSide(color: Colors.blue)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.05),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              color: Colors.grey[300],
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid password.';
                                  } else if (value.length < 6) {
                                    return 'Password should be at least 6 characters long';
                                  } else {
                                    password = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                    icon: Icon(_icon),
                                    onPressed: () {
                                      if (_obscureText) {
                                        _obscureText = false;
                                        _icon = Icons.lock_open;
                                      } else {
                                        _obscureText = true;
                                        _icon = Icons.lock_outline;
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                      const BorderSide(color: Colors.blue)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            gradient: backgroundGradient,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 5),
                                blurRadius: 6,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FloatingActionButton.extended(
                            heroTag: 'SignUpButton',
                            isExtended: true,
                            onPressed: () {
                              if (_signUpKey.currentState!.validate()){
                                busyVal.value = true;
                                authInstance.signUp(email, password).then((user) {
                                  busyVal.value = false;
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 3),
                                    content: Text(
                                      user.email.toString(),
                                      style: const TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.black,
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Provider<User>(create: (_) => user,child: const AdminPage(),)), (route) => false);
                                }).onError((error, stackTrace) {
                                  busyVal.value = false;
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 3),
                                    content: Text(
                                      error.toString(),
                                      style: const TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.black,
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                });
                              }
                            },
                            clipBehavior: Clip.antiAlias,
                            label: const Text(
                              'CREATE ACCOUNT',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            disabledElevation: 0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.02),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/water_world_logo.png'),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
