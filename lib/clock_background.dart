import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ClockBackground extends StatefulWidget {

  ClockBackground({this.isAm});
  bool isAm;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClockBackgroundState();
  }

}

class ClockBackgroundState extends State<ClockBackground>{



  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[



        Positioned(
          width: height/3.2,
          height: height/3.2,
          top: 50,
          left: 30,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.pink[900].withOpacity(0.3)),
        ),

        Positioned(
            width: height/1.8,
            height: height/1.8,
            top: 150,
            left: 130,
            child: widget.isAm ? SvgPicture.asset("images/sun.svg",) : SvgPicture.asset("images/sun.svg",),

        ),

        Positioned(
          width: height/1.8,
          height: height/1.8,
          top: 150,
          left: 130,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.black26),

        ),


        Positioned(
          width: height/7,
          height: height/7,
          top: 20,
          left: 300,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.pink[900].withOpacity(0.3)),
        ),

        Positioned(
          width: height/2.2,
          height: height/2.2,
          top: 15,
          left: 430,
          child: CircleAvatar(
              minRadius: 100,
              maxRadius: 100,
              backgroundColor: Colors.pink[900].withOpacity(0.4)),
        ),


      ],
    );
  }

}

