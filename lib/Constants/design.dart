import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

LinearGradient backgroundGradient = const LinearGradient(colors: [
  Color.fromRGBO(30, 157, 208, 0.8),
  Color.fromRGBO(2, 107, 203, 1),
], begin: Alignment.topLeft);

const loader = Center(child: CircularProgressIndicator(
  color: Colors.blue,
),);

SizedBox logo = SizedBox(
  height: 120,
  width: 120,
  child: MoveWindow(
    child: SizedBox(
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20),
        child: Image.asset('assets/images/divaz_logo.png', fit: BoxFit.cover, cacheWidth: 120, cacheHeight: 120,),
      ),
    ),
  ),
);