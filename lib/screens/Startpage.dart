import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  final List  _selectedPage= [
     Page1(),
     Page2(),
     Page3()
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: 3,
        itemBuilder: (ctx,index) => _selectedPage[index],

    );
  }
}

class Page1 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
class Page2 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
class Page3 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
    );
  }
}

