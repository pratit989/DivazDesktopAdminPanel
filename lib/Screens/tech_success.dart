import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_page.dart';

class TechSuccess extends StatelessWidget {
  const TechSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _index = context.read<SelectedIndex>();
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/add_tech_graphic.png', scale: 1.5,),
          Text('Technician Successfully Registered!', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w800),),
          RichText(text: TextSpan(
              children: [
                TextSpan(text: 'Return', recognizer: TapGestureRecognizer()..onTap = () {_index.setValue(0);}, style: const TextStyle(color: Colors.blue)),
                const TextSpan(text: ' to dashboard', style: TextStyle(color: Colors.black))
              ]
          ),),
        ],
      ),
    );
  }
}
