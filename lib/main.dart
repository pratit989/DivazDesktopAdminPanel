import 'package:admin/BLoC/firestore_bloc.dart';
import 'package:admin/Constants/design.dart';
import 'package:admin/Screens/admin_page.dart';
import 'package:admin/Screens/sign_in.dart';
import 'package:admin/token_store.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const apiKey = 'AIzaSyB8BVZfSd29ub4p8HVk-P12WxRm1kt39uA';
const projectID = 'divaz-8e0a9';

Future<void> main() async {
  FirebaseAuth.initialize(apiKey, await PreferencesStore.create());
  runApp(const MyApp());
  doWhenWindowReady(() {
    var initialSize = const Size(1080, 600);
    appWindow.title = 'Divaz Admin Panel';
    appWindow.minSize = initialSize;
    appWindow.maximize();
    appWindow.show();
  });
  WidgetsApp.debugAllowBannerOverride = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authInstance = FirebaseAuth.instance;
    return MultiProvider(
      providers: [
        Provider<FirebaseAuth>(
          create: (_) => authInstance,
        ),
        Provider<Firestore>(create: (BuildContext context) => Firestore(projectID, auth: context.read<FirebaseAuth>())),
        Provider<DataService>(create: (BuildContext context) => DataService(),)
      ],
      child: MaterialApp(
          title: 'Divaz Admin Panel',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AuthCheck()),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authInstance = context.read<FirebaseAuth>();
    ValueNotifier<bool> signInStat = ValueNotifier<bool>(authInstance.isSignedIn);
    return ValueListenableBuilder(
      valueListenable: signInStat,
      builder: (BuildContext context, value, Widget? child) {
        if (value != null && value == true) {
          return FutureBuilder(
              future: authInstance.getUser(),
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting && !snapshot.hasError && snapshot.hasData) {
                  return Provider<User>(create: (_) => snapshot.data!, child: const AdminPage());
                }
                return loader;
              });
        } else if (value != null && value == false) {
          return const SignIn();
        } else {
          return loader;
        }
      },
    );
  }
}
