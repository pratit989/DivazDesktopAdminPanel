import 'package:admin/Constants/design.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_page.dart';

class AddTech extends StatefulWidget {
  const AddTech({Key? key}) : super(key: key);

  @override
  _AddTechState createState() => _AddTechState();
}

class _AddTechState extends State<AddTech> {
  final _techCreateKey = GlobalKey<FormState>();
  late bool _obscureText = true;
  late IconData _icon = Icons.lock_outline;
  late String email;
  late String password;
  late String name;
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final authInstance = context.read<FirebaseAuth>();
    final _index = context.read<SelectedIndex>();
    bool busy = false;
    ValueNotifier busyVal = ValueNotifier(busy);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          text: TextSpan(children: [
        WidgetSpan(
            child: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            _index.setValue(0);
          },
        )),
        WidgetSpan(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        )),
        TextSpan(
            text: 'Add Technicians',
            style: TextStyle(color: Colors.blue[900], fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.w600))
      ])),
      ValueListenableBuilder(
        valueListenable: busyVal,
        builder: (BuildContext context, value, Widget? child) {
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Form(
                key: _techCreateKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.grey[300],
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid name.';
                              } else {
                                name = value;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Name',
                              border: InputBorder.none,
                              focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.grey[300],
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Please enter a valid mobile number.';
                              } else {
                                phoneNumber = value;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              hintText: 'Phone Number',
                              border: InputBorder.none,
                              focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
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
                              focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
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
                              focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                      child: Container(
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
                            if (_techCreateKey.currentState!.validate()) {
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
                                context
                                    .read<Firestore>()
                                    .document('Technicians/${user.id}')
                                    .set({'Name': name, 'Email': email, 'PhoneNumber': phoneNumber, 'CurrentCase': null});
                                _index.setValue(7);
                              }).onError((AuthException error, stackTrace) {
                                busyVal.value = false;
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 3),
                                  content: Text(
                                    error.message,
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
                            'REGISTER',
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
                    ),
                  ],
                )),
          );
        },
      ),
    ]);
  }
}
