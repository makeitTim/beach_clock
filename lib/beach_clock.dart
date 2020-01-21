//
//   BEACH CLOCK
//
// Made by Tim Davidson Jan. 20, 2020
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'utility.dart';

///
class BeachClock extends StatefulWidget {
  @override
  _BeachClockState createState() => _BeachClockState();
}

/// The state. File private.
/// Animation Controller requires a Ticker Provider
class _BeachClockState extends State<BeachClock> with SingleTickerProviderStateMixin {

  // Properties
  AnimationController _animationController;
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  // used for fast time. note it's based on frames not time.
  bool _isDemo = true;
  int _demoTime = 0;

  // Color constants
  final Color kSkyColor = Color.fromRGBO(80, 163, 217, 1.0);
  final Color kSunColor = Color.fromRGBO(255, 221, 21, 1.0);
  final Color kCloudRedColor = Color.fromRGBO(233, 65, 60, 1.0);
  final Color kPalmsDayColor = Color.fromRGBO(38, 34, 97, 1.0);
  final Color kPalmsNightColor = Color.fromRGBO(48, 32, 53, 1.0);
  final Color kTimeDayColor = Color.fromRGBO(199, 255, 217, 0.5);
  final Color kTimeNightColor = Color.fromRGBO(249, 236, 183, 0.5);

  // Images
  //Image _cloud1Image;
  //Image _cloud2Image;
  //Image _cloud3Image;
  //Image _cloud4Image;
  //Image _cloud5Image;
  //Image _cloud6Image;
  Image _dayHorizonImage;
  Image _dayPalmsImage;
  //Image _moonImage;
  Image _nightHorizonImage;
  Image _nightPalmsImage;
  Image _nightSkyImage;
  //Image _reflectionImage;
  //Image _sunImage;
  Image _wave1Image;
  Image _wave2Image;
  Image _wave3Image;

  @override
  void initState() {

    super.initState();
    _updateTime();

    //_cloud1Image = Image(image: AssetImage('assets/images/cloud1.png'));
    //_cloud2Image = Image(image: AssetImage('assets/images/cloud2.png'));
    //_cloud3Image = Image(image: AssetImage('assets/images/cloud3.png'));
    //_cloud4Image = Image(image: AssetImage('assets/images/cloud4.png'));
    //_cloud5Image = Image(image: AssetImage('assets/images/cloud5.png'));
    //_cloud6Image = Image(image: AssetImage('assets/images/cloud6.png'));
    _dayHorizonImage = Image(image: AssetImage('assets/images/day_horizon.png'));
    _dayPalmsImage = Image(image: AssetImage('assets/images/day_palms.png'));
    //_moonImage = Image(image: AssetImage('assets/images/moon.png'));
    _nightHorizonImage = Image(image: AssetImage('assets/images/night_horizon.png'));
    _nightPalmsImage = Image(image: AssetImage('assets/images/night_palms.png'));
    _nightSkyImage = Image(image: AssetImage('assets/images/night_sky.png'));
    //_reflectionImage = Image(image: AssetImage('assets/images/reflection.png'));
    //_sunImage = Image(image: AssetImage('assets/images/sun.png'));
    _wave1Image = Image(image: AssetImage('assets/images/wave1.png'));
    _wave2Image = Image(image: AssetImage('assets/images/wave2.png'));
    _wave3Image = Image(image: AssetImage('assets/images/wave3.png'));

    _animationController = AnimationController(
      value: 0.0,
      lowerBound : 0.0,
      upperBound: 1.0,
      duration:  const Duration(milliseconds: 1),
      vsync: this,
    );
    _animationController.addListener(() {
      setState((){}); //Note: does not go through updateTime() so _dateTime not set, so build uses value..
    });               // to decide what actions to perform
    _animationController.repeat(); //keep going

  }

  @override
  void didUpdateWidget(BeachClock oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

    });

    // Had to null check this for some reason.
    if (_animationController != null) {
      // keep animation controller in sync with the timer, so eg Value = 0.016666 = 1 second
      _animationController.value = (_dateTime.second + (_dateTime.millisecond/1000)) / 60.0;
      _animationController.repeat();
    }
  }

  // --------------------------------------------------------------------------------------

  /// The big build method. I rather DISLIKE methods much large than a screen height.
  @override
  Widget build(BuildContext context) {
    // I guess I'm doing this again. I really wanted this component to be given it's
    // size, that would be good component based ui structure design. 
    MediaQueryData media = MediaQuery.of(context);
    Size size = aspectRatioIn(800 / 480, media.size);

    // base values used for positioning
    double w = size.width;
    double h = size.height;
    double a = _animationController.value;

    // Same percentage values. I've tended to break up into 25 x 15 grid.
    double g = w / 25.0;
    double horizonY = g * 9;

    // time values.
    int hour;
    int min;
    String timeString;
    if (_isDemo) {
      // EXTRA FAST TIME FOR TESTING!!!
      _demoTime += 1;
      min = _demoTime % 1440; // 1440 min in a day
      hour = (min / 60.0).floor();
      min = min % 60;
      int hourTwelve = (hour % 12 == 0) ? 12 : hour % 12;
      timeString = hourTwelve.toString() + ':' + min.toString().padLeft(2, '0');
    } else {
      // ACTUAL TIME
      hour = _dateTime.hour; // will be 24-hour format, ie 00 to 23
      min = _dateTime.minute;
      timeString = DateFormat('h:mm').format(_dateTime);
    }

    // Assuming 6-8 it transitions from day to night
    bool isDay = (hour >= 6 && hour < 20);
    bool isNight = (hour >= 18 || hour < 8);

    double dayNightTrans = 1.0;
    if (isDay && isNight) {
      // draw transition. over 2 hours
      dayNightTrans = min / 120.0;
      if (hour == 7 || hour == 19) { // second hour
        dayNightTrans += 0.5;
      }
      if (hour < 12) { // invert in morning
        dayNightTrans = 1.0 - dayNightTrans;
      }
      //print('$hour : $min  d:$isDay  n:$isNight    dayNightTrans $dayNightTrans');
    }

    // stack of elements to draw
    List<Widget> stack = [];

    // SKY
    if (isNight) {
      if (dayNightTrans < 1.0 && dayNightTrans >= 0.0) {
        stack.add(Positioned(top: 0.0, left: 0.0, width: w, child:
          Opacity(opacity: dayNightTrans, child: _nightSkyImage)
        ));

      } else {
        stack.add(Positioned(top: 0.0, left: 0.0, width: w, child: _nightSkyImage));
      }
    }

    // sun image is 138 x 138, and needs to be colored
    //Image sunImage = Image
    //stack.add(Positioned(top: horizonY, left: 0.0, width: (138.0 / 800.0) * w, child: sunImage));

    // CLOUDS
    //stack.add(Positioned(left: w * 0.01 * a, top: h * 0.01 * a, child: ClipRect(child: _cloud1Image)));
    //stack.add(Positioned(left: w * 0.02 * a, top: h * 0.3 * a,  child: ClipRect(child: _cloud2Image)));
    //stack.add(Positioned(left: w * 0.05 * a, top: h * 0.4 * a,  child: ClipRect(child: _cloud3Image)));


    // HORIZON

    if (isDay) {
      stack.add(Positioned(top: horizonY, left: 0.0, width: w, child: _dayHorizonImage));
    }
    if (isNight) {
      if (dayNightTrans < 1.0 && dayNightTrans >= 0.0) {
        stack.add(Positioned(top: horizonY, left: 0.0, width: w, child:
          Opacity(opacity: dayNightTrans, child: _nightHorizonImage)
        ));

      } else {
        stack.add(Positioned(top: horizonY, left: 0.0, width: w, child: _nightHorizonImage));
      }
    }



    // WAVES
    double waveXstart = w * -0.2;
    double waveXrange = w * 0.2;
    double waveYstart = h * 0.6;
    double waveYrange = h * 0.1;

    // HATE THIS. This should be a seperate method run thrice.
    // Each animation element should be a component.

    if (min % 3 != 0) {
      double wave1w = w * (827.0 / 800.0);
      double wave1A = a <= 0.5 ? a : 1.0 - a;
      double wave1X = waveXstart + (waveXrange * a);
      double wave1Y = waveYstart + (waveYrange * a);

      stack.add(Positioned(left: wave1X, top: wave1Y, width: wave1w, child: Opacity(opacity: wave1A, child: _wave1Image)));
    }

    if (min % 3 != 1) {
      double a2 = a + 0.333;
      if (a2 > 1.0) { a2 -= 1.0; }
      double wave2w = w * (827.0 / 800.0);
      double wave2A = a2 <= 0.5 ? a2 : 1.0 - a2;
      double wave2X = waveXstart + (waveXrange * a2);
      double wave2Y = waveYstart + (waveYrange * a2);

      stack.add(Positioned(left: wave2X, top: wave2Y, width: wave2w, child: Opacity(opacity: wave2A, child: _wave2Image)));
    }

    if (min % 3 != 2) {
      double a3 = a + 0.667;
      if (a3 > 1.0) { a3 -= 1.0; }
      double wave3w = w * (827.0 / 800.0);
      double wave3A = a3 <= 0.5 ? a3 : 1.0 - a3;
      double wave3X = waveXstart + (waveXrange * a3);
      double wave3Y = waveYstart + (waveYrange * a3);

      stack.add(Positioned(left: wave3X, top: wave3Y, width: wave3w, child: Opacity(opacity: wave3A, child: _wave3Image)));
    }



    // TIME TEXT
    Color textColor = kTimeDayColor;
    if (isNight) {
      if (dayNightTrans < 1.0 && dayNightTrans >= 0.0) {
        textColor = Color.lerp(kTimeDayColor, kTimeNightColor, dayNightTrans);
      } else {
        textColor = kTimeNightColor;
      }
    }

    final fontSize = h * 0.8;
    final timeStyle = TextStyle(
      color: textColor,
      fontFamily: 'VAGRoundedLTCYRW10-Black',
      fontSize: fontSize,
      decoration: TextDecoration.none // LOL, by default Flutter text has 2 yellow underlines!?!?
    );
    //stack.add(Center(child: Text(timeString, style: timeStyle)));
    Text timeText = Text(timeString, style: timeStyle);
    stack.add(Center(child:
      FittedBox(fit: BoxFit.fitWidth, alignment: Alignment.center, child: timeText))
    );

    // PALM TREES
    if (isDay) {
      stack.add(Positioned(left: 0.0, top: 0.0, width: w, height: h, child: _dayPalmsImage));
    }
    if (isNight) {
      if (dayNightTrans < 1.0 && dayNightTrans >= 0.0) {
        stack.add(Positioned(top: 0.0, left: 0.0, width: w, child:
          Opacity(opacity: dayNightTrans, child: _nightPalmsImage)
        ));

      } else {
        stack.add(Positioned(left: 0.0, top: 0.0, width: w, child: _nightPalmsImage));
      }
    }


    return GestureDetector(
      onTap: () {
        _isDemo = !_isDemo;
      },
      child: Container(
        color: kSkyColor,
        child: Stack(
          children: stack,
        )
      ),
    );

  }
    
  
}


