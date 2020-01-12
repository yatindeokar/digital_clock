import 'dart:async';
import 'dart:ui';

import 'package:digital_clock/clock_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFFFFFFFF),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String minute = "0", hour = "0", oldMin = "", oldHr = "";

  PageController _controller;
  int _currentPage = 0;
  String mFontFamily = "RubicBold";

  List<Shadow> _darkShadow = [
    Shadow(
      offset: Offset(0.5, 0.5),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(0.5, 0.5),
      blurRadius: 8.0,
      color: Color.fromARGB(125, 0, 0, 255),
    ),
  ];

  List<Shadow> _lightShadow = [
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 2.0,
      color: Colors.transparent,
    ),
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 2.0,
      color: Colors.transparent,
    ),
  ];

  var _hourTextStyle;

  @override
  void initState() {
    super.initState();

    _portraitModeOnly();
    widget.model.addListener(_updateModel);

    _updateTime();
    _updateModel();

    //Carrosal---------
    _controller = new PageController(
      initialPage: _currentPage,
      keepPage: false,
      viewportFraction: 0.32,
    );
  }

  Widget _animatedWidget;
  changeOpacity() {
    _dateTime = DateTime.now();

    // Update once per minute. If you want to update every second, use the
    // following code.
    _timer = Timer(
      Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateTime,
    );
    // Update once per second, but make sure to do it at the beginning of each
    // new second, so that the clock is accurate.
//     _timer = Timer(
//       Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
//       _updateTime,
//     );
//    });
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.animateToPage(int.parse(minute),
        duration: Duration(seconds: 1), curve: Curves.ease);

    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hourTextStyle = TextStyle(
        fontFamily: mFontFamily,
        fontSize: MediaQuery.of(context).size.width / 2.8,
        fontWeight: FontWeight.w800,
        color: Colors.white);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _updateTime() {
    setState(() {
      changeOpacity();

      if (oldHr != hour) {
        _animatedWidget = Text(
          hour,
          style: _hourTextStyle,
          key: UniqueKey(),
        );
      }

      Future.delayed(Duration(seconds: 1), () {
        _controller.animateToPage(int.parse(minute),
            duration: Duration(seconds: 1), curve: Curves.ease);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    minute = DateFormat('mm').format(_dateTime);

    if (oldHr != hour) {
      _animatedWidget = Text(
        hour,
        style: _hourTextStyle,
        key: UniqueKey(),
      );
    }

    oldHr = hour;
    oldMin = minute;

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(2.0, -5.0),
                      end: Alignment(0.0, 1.0),
                      colors: [
                        Color(0xFF8000FF),
                        Color(0xFF090000),
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Stack(
                overflow: Overflow.clip,
                children: <Widget>[
                  ClockBackground(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AnimatedSwitcher(
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        duration: const Duration(seconds: 1),
                        child: _animatedWidget,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.width / 3.3
                              : MediaQuery.of(context).size.height / 2.2,
                          child: new Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Container(
                                child: new PageView.builder(
                                    physics: new NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    onPageChanged: (value) {
                                      setState(() {
                                        _currentPage = value;
                                      });
                                    },
                                    controller: _controller,
                                    itemBuilder: (context, index) =>
                                        builder(index)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  builder(int index) {
    return new AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - index;
          value = (1 - (value.abs() * .68)).clamp(0.0, 1.0);
        }

        return new Center(
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * 110,
            width: Curves.easeOut.transform(value) * 190,
            child: FittedBox(
              fit: BoxFit.cover,
              child: child,
            ),
          ),
        );
      },
      child: new Container(
        child: Center(
            child: AnimatedContainer(
          duration: Duration(seconds: 3),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              index.toString().padLeft(2, "0"),
              style: TextStyle(
                  fontFamily: mFontFamily,
                  fontWeight: FontWeight.w900,
                  shadows: index == _currentPage ? _darkShadow : _lightShadow,
                  color: index == _currentPage
                      ? Colors.white
                      : Colors.white.withOpacity(0.3)),
            ),
          ),
        )),
      ),
    );
  }
}
