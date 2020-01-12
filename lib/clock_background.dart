import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClockBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          width: 100,
          height: 100,
          top: 50,
          left: 30,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.pink[900].withOpacity(0.4)),
        ),
        Positioned(
          width: 200,
          height: 200,
          top: 150,
          left: 200,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.pink[900].withOpacity(0.4)),
        ),
        Positioned(
          width: 90,
          height: 90,
          top: 20,
          left: 300,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.pink[900].withOpacity(0.4)),
        ),
      ],
    );
  }
}
