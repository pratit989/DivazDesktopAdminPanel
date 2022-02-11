import 'package:admin/Constants/design.dart';
import 'package:admin/Screens/admin_page.dart';
import 'package:admin/Screens/sign_up.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _loginKey = GlobalKey<FormState>();
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
          return Stack(
            children: [
              Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: kToolbarHeight,
                    child: MoveWindow(),
                  ),
                  elevation: 0,
                  actions: [
                    MinimizeWindowButton(),
                    MaximizeWindowButton(),
                    CloseWindowButton(),
                  ],
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            top: MediaQuery.of(context).size.height * 0.2,
                            bottom: MediaQuery.of(context).size.height * 0.2),
                        child: Form(
                            key: _loginKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height * 0.05),
                                  child: Text(
                                    'Login to access Dashboard!',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w800,
                                        fontSize: MediaQuery.of(context).size.shortestSide *
                                            0.04),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height * 0.05),
                                  child: Text(
                                    'Enter Admin Credentials',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: MediaQuery.of(context).size.shortestSide *
                                            0.025),
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
                                            return '   Please enter a valid email address.';
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
                                            return '    Please enter a valid password.';
                                          } else if (value.length < 6) {
                                            return '    Password should be at least 6 characters long';
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
                                  width: MediaQuery.of(context).size.width * 0.12,
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
                                    heroTag: 'SignInButton',
                                    isExtended: true,
                                    onPressed: () {
                                      if (_loginKey.currentState!.validate()) {
                                        busyVal.value = true;
                                        authInstance.signIn(email, password).then((user) {
                                          busyVal.value = false;
                                          final snackBar = SnackBar(
                                            duration: const Duration(seconds: 3),
                                            content: Text(
                                              'Welcome ${user.email}',
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
                                      'PROCEED',
                                      style: TextStyle(fontWeight: FontWeight.w800),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    hoverElevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    disabledElevation: 0,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: backgroundGradient,
                            borderRadius:
                            const BorderRadius.horizontal(left: Radius.circular(50))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height * 0.04),
                              child: Image.asset(
                                'assets/images/tech_illustration.png',
                                height: MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                            ),
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03,
                              ),
                              child: FloatingActionButton.extended(
                                isExtended: true,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                                },
                                clipBehavior: Clip.antiAlias,
                                label: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800, color: Colors.blue[800]),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                floatingActionButton: SizedBox(
                  height: kToolbarHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/water_world_logo.png'),
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              ),
              logo,
            ]
          );
      },
    );
  }
}
